import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hockey_organizer/components/CustomTextField.dart';
import 'package:hockey_organizer/screens/reset_password.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:hockey_organizer/utils/buble_indicator_painter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../app_localization.dart';
import '../authentication_wrapper.dart';
import '../contants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _loginPasswordFocusNode = FocusNode();
  FocusNode _loginEmailFocusNode = FocusNode();

  FocusNode _registerNameFocusNode = FocusNode();
  FocusNode _registerEmailFocusNode = FocusNode();
  FocusNode _registerPasswordFocusNode = FocusNode();
  FocusNode _registerRepeatPasswordFocusNode = FocusNode();

  TextEditingController _loginEmailController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();

  TextEditingController _registerNameController = TextEditingController();
  TextEditingController _registerEmailController = TextEditingController();
  TextEditingController _registerPasswordController = TextEditingController();
  TextEditingController _registerRepeatPasswordController = TextEditingController();

  PageController _pageController;

  String _errorText = '';
  bool isLoading = false;

  Color leftTabColor = Colors.black;
  Color rightTabColor = Colors.white;

  void unFocusAllNodes() {
    _loginEmailFocusNode.unfocus();
    _loginPasswordFocusNode.unfocus();
    _registerNameFocusNode.unfocus();
    _registerEmailFocusNode.unfocus();
    _registerPasswordFocusNode.unfocus();
    _registerRepeatPasswordFocusNode.unfocus();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  @override
  void dispose() {
    _registerPasswordFocusNode.dispose();
    _registerEmailFocusNode.dispose();
    _registerNameFocusNode.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  void _onPressTabBarSignInButton() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void _onPressTabBarSignUPButton() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void onPressSignInButton(BuildContext context, AppLocalizations appLocalizations) async {
    String email = _loginEmailController.text.trim();
    if (await validInternetConnection(appLocalizations) == false) return;
    if (validEmailAddress(email.toLowerCase(), appLocalizations) == false) return;
    setState(() {
      isLoading = true;
    });
    await context
        .read<AuthenticationService>()
        .signIn(
          context,
          email: _loginEmailController.text.trim().toLowerCase(),
          password: _loginPasswordController.text.trim(),
        )
        .then((error) {
      setState(() {
        _errorText = error;
        isLoading = false;
      });
    });
    if (_errorText != '') {
      showInSnackBar(_errorText);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()));
    }
  }

  void onPressSignUpButton(BuildContext context, AppLocalizations appLocalizations) async {
    String emailAddress = _registerEmailController.text.trim();
    if (await validInternetConnection(appLocalizations) == false) return;
    if (validNameAndSurname(appLocalizations) == false) return;
    if (validEmailAddress(emailAddress.toLowerCase(), appLocalizations) == false) return;
    if (validPassword(appLocalizations) == false) return;
    if (validRepeatPassword(appLocalizations) == false) return;

    setState(() {
      isLoading = true;
    });
    await context
        .read<AuthenticationService>()
        .signUp(
          context,
          displayName: _registerNameController.text.trim(),
          email: _registerEmailController.text.trim().toLowerCase(),
          password: _registerPasswordController.text.trim(),
        )
        .then((error) {
      setState(() {
        _errorText = error;
        isLoading = false;
      });
    });
    if (_errorText != '') {
      showInSnackBar(_errorText);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()));
    }
  }

  void onPressGoogleIcon() async {
    await context.read<AuthenticationService>().signInByGoogle();
  }

  bool validEmailAddress(String emailAddress, AppLocalizations appLocalizations) {
    if (emailAddress.isEmpty == true) {
      setState(() {
        _errorText = appLocalizations.translate('enter_email_address');
      });
      showInSnackBar(_errorText);
      return false;
    }
    bool isValid = EmailValidator.validate(emailAddress);
    if (isValid == false) {
      setState(() {
        _errorText = appLocalizations.translate('invalid_email_address');
      });
      showInSnackBar(_errorText);
      return isValid;
    }
    return isValid;
  }

  bool validNameAndSurname(AppLocalizations appLocalizations) {
    String name = _registerNameController.text.trim();
    if (name.isEmpty == true) {
      setState(() {
        _errorText = appLocalizations.translate('enter_your_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (name.length > 20) {
      setState(() {
        _errorText = appLocalizations.translate('so_long_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
  }

  bool validPassword(AppLocalizations appLocalizations) {
    String password = _registerPasswordController.text.trim();
    if (password.length < 8) {
      setState(() {
        _errorText = appLocalizations.translate('weak_password');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
  }

  bool validRepeatPassword(AppLocalizations appLocalizations) {
    String password = _registerPasswordController.text.trim();
    String repeatedPassword = _registerRepeatPasswordController.text.trim();
    if (password != repeatedPassword) {
      setState(() {
        _errorText = appLocalizations.translate('passwords_not_same');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
  }

  Future<bool> validInternetConnection(AppLocalizations appLocalizations) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile)
      return true;
    else if (connectivityResult == ConnectivityResult.wifi) return true;
    setState(() {
      _errorText = appLocalizations.translate('no_internet_connection');
    });
    showInSnackBar(_errorText);
    return false;
  }

  void focusLoginPasswordTextField(String value) => _loginPasswordFocusNode.requestFocus();
  void unFocusLoginPasswordTextField(String value) => _loginPasswordFocusNode.unfocus();

  void focusRegisterEmailTextField(String value) => _registerEmailFocusNode.requestFocus();
  void focusRegisterPasswordTextField(String value) => _registerPasswordFocusNode.requestFocus();
  void focusRegisterRepeatPasswordTextField(String value) =>
      _registerRepeatPasswordFocusNode.requestFocus();
  void unFocusRegisterRepeatPasswordTextField(String value) =>
      _registerRepeatPasswordFocusNode.unfocus();

  void showInSnackBar(String description) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context, AppLocalizations appLocalizations) {
    TextStyle _menuTextStyle =
        TextStyle(color: rightTabColor, fontSize: 18, fontWeight: FontWeight.w900);

    return Container(
      width: 300.0,
      height: 50.0,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Color(0x552B2B2B), borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onPressTabBarSignInButton,
                child: Text(
                  appLocalizations.translate('sign_in'),
                  style: _menuTextStyle.copyWith(color: leftTabColor),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onPressTabBarSignUPButton,
                child: Text(appLocalizations.translate('sign_up'),
                    textAlign: TextAlign.center, style: _menuTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrTextWithDividers(AppLocalizations appLocalizations) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white10, Colors.white],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              appLocalizations.translate('or'),
              style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansMedium"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white10],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, String text,
      {bool isLoginButton = true, double margin = 170}) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(top: margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Constants.START_GRADIENT_COLOR,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Constants.START_GRADIENT_COLOR,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
            colors: [Constants.START_GRADIENT_COLOR, Constants.END_GRADIENT_COLOR],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Constants.END_GRADIENT_COLOR,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 42),
            child: Text(
              appLocalizations.translate(text),
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ),
          onPressed: () {
            if (isLoginButton == true) {
              onPressSignInButton(context, appLocalizations);
            } else {
              onPressSignUpButton(context, appLocalizations);
            }
          }),
    );
  }

  Widget _buildSignIn(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _loginEmailController,
                        focusNode: _loginEmailFocusNode,
                        hintText: appLocalizations.translate('email_address'),
                        type: TextFieldType.EMAIL,
                        onFieldSubmitted: focusLoginPasswordTextField,
                      ),
                      _buildDivider(),
                      CustomTextField(
                        controller: _loginPasswordController,
                        focusNode: _loginPasswordFocusNode,
                        hintText: appLocalizations.translate('password'),
                        type: TextFieldType.PASSWORD,
                        onFieldSubmitted: unFocusLoginPasswordTextField,
                        isRepeatingPassword: true,
                      ),
                    ],
                  ),
                ),
              ),
              _buildConfirmButton(context, 'sign_in'),
            ],
          ),
          _buildOrTextWithDividers(appLocalizations),
          const SizedBox(height: 10),
          FlatButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ResetPasswordScreen())),
              child: Text(
                appLocalizations.translate('forgot_password'),
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialMediaButton('assets/icon_google.png', onPressGoogleIcon),
              const SizedBox(width: 25),
              _buildSocialMediaButton('assets/icon_facebook.png', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _registerNameController,
                          focusNode: _registerNameFocusNode,
                          hintText: appLocalizations.translate('name_and_surname'),
                          type: TextFieldType.NAME_AND_SURNAME,
                          onFieldSubmitted: focusRegisterEmailTextField),
                      _buildDivider(),
                      CustomTextField(
                          controller: _registerEmailController,
                          focusNode: _registerEmailFocusNode,
                          hintText: appLocalizations.translate('email_address'),
                          type: TextFieldType.EMAIL,
                          onFieldSubmitted: focusRegisterPasswordTextField),
                      _buildDivider(),
                      CustomTextField(
                          controller: _registerPasswordController,
                          focusNode: _registerPasswordFocusNode,
                          hintText: appLocalizations.translate('password'),
                          type: TextFieldType.PASSWORD,
                          onFieldSubmitted: focusRegisterRepeatPasswordTextField),
                      _buildDivider(),
                      CustomTextField(
                          controller: _registerRepeatPasswordController,
                          focusNode: _registerRepeatPasswordFocusNode,
                          hintText: appLocalizations.translate('repeat_password'),
                          type: TextFieldType.PASSWORD,
                          onFieldSubmitted: unFocusRegisterRepeatPasswordTextField,
                          isRepeatingPassword: true),
                    ],
                  ),
                ),
              ),
              _buildConfirmButton(context, 'sign_up', isLoginButton: false, margin: 340),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaButton(String imagePath, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Image.asset(imagePath, width: 40, height: 40)),
    );
  }

  Widget _buildDivider() {
    return Container(width: 250.0, height: 1.0, color: Colors.grey[400]);
  }

  Widget _buildContent(BuildContext context, AppLocalizations appLocalizations) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: SpinKitCubeGrid(size: 55, color: Colors.black87),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
              child: GestureDetector(
            onTap: unFocusAllNodes,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Constants.START_GRADIENT_COLOR, Constants.END_GRADIENT_COLOR],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 75),
                  Image(width: 250.0, height: 191.0, image: AssetImage('assets/hockey.png')),
                  _buildMenuBar(context, appLocalizations),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            rightTabColor = Colors.white;
                            leftTabColor = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            rightTabColor = Colors.black;
                            leftTabColor = Colors.white;
                          });
                        }
                      },
                      children: [
                        ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context, appLocalizations)),
                        ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context, appLocalizations)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return _buildContent(context, appLocalizations);
  }
}
