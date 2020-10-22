import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hockey_organizer/components/CustomTextField.dart';
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

  final FocusNode _loginEmailFocusNode = FocusNode();
  final FocusNode _loginPasswordFocusNode = FocusNode();

  final FocusNode _registerPasswordFocusNode = FocusNode();
  final FocusNode _registerEmailFocusNode = FocusNode();
  final FocusNode _registerNameFocusNode = FocusNode();
  final FocusNode _registerRepeatPasswordFocusNode = FocusNode();

  TextEditingController _loginEmailController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();

  TextEditingController _signUpEmailController = TextEditingController();
  TextEditingController _signUpNameController = TextEditingController();
  TextEditingController _signUpPasswordController = TextEditingController();
  TextEditingController _signUpConfirmPasswordController = TextEditingController();

  PageController _pageController;

  String _errorText = '';
  bool isLoading = false;

  Color leftTabColor = Colors.black;
  Color rightTabColor = Colors.white;

  void unFocusAllNodes() {
    _loginEmailFocusNode.unfocus();
    _loginPasswordFocusNode.unfocus();
    _registerPasswordFocusNode.unfocus();
    _registerEmailFocusNode.unfocus();
    _registerNameFocusNode.unfocus();
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
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _onPressTabBarSignUPButton() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void onPressSignInButton(BuildContext context, AppLocalizations appLocalizations) async {
    if (validEmailAddress(_loginEmailController.text.trim().toLowerCase(), appLocalizations) ==
        false) {
      return;
    }
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
    if (validNameAndSurname(_signUpNameController.text.trim(), appLocalizations) == false) {
      return;
    }
    if (validEmailAddress(_signUpEmailController.text.trim().toLowerCase(), appLocalizations) ==
        false) {
      return;
    }
    if (validPassword(_signUpPasswordController.text.trim(), appLocalizations) == false) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await context
        .read<AuthenticationService>()
        .signUp(
          context,
          displayName: _signUpNameController.text.trim(),
          email: _signUpEmailController.text.trim().toLowerCase(),
          password: _signUpPasswordController.text.trim(),
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

  bool validEmailAddress(String userInput, AppLocalizations appLocalizations) {
    if (userInput.isEmpty == true) {
      setState(() {
        _errorText = appLocalizations.translate('enter_email_address');
      });
      showInSnackBar(_errorText);
      return false;
    }
    bool isValid = EmailValidator.validate(userInput);
    if (isValid == false) {
      setState(() {
        _errorText = appLocalizations.translate('invalid_email_address');
      });
      showInSnackBar(_errorText);
      return isValid;
    }
    return isValid;
  }

  bool validNameAndSurname(String userInput, AppLocalizations appLocalizations) {
    if (userInput.isEmpty == true) {
      setState(() {
        _errorText = appLocalizations.translate('enter_your_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (userInput.length > 20) {
      setState(() {
        _errorText = appLocalizations.translate('so_long_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
  }

  bool validPassword(String userInput, AppLocalizations appLocalizations) {
    if (userInput.length < 8) {
      setState(() {
        _errorText = appLocalizations.translate('weak_password');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
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

  Widget _buildTextField(TextEditingController controller, FocusNode node, String hintText,
      TextFieldType type, Function(String) onFieldSubmitted,
      {bool isRepeatingPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: CustomTextField(
        controller: controller,
        focusNode: node,
        hintText: hintText,
        type: type,
        onFieldSubmitted: onFieldSubmitted,
        isRepeatingPassword: isRepeatingPassword,
      ),
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
                      _buildTextField(
                          _loginEmailController,
                          _loginEmailFocusNode,
                          appLocalizations.translate('email_address'),
                          TextFieldType.EMAIL,
                          focusLoginPasswordTextField),
                      _buildDivider(),
                      _buildTextField(
                          _loginPasswordController,
                          _loginPasswordFocusNode,
                          appLocalizations.translate('password'),
                          TextFieldType.PASSWORD,
                          unFocusLoginPasswordTextField,
                          isRepeatingPassword: true),
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
              onPressed: () {},
              child: Text(
                appLocalizations.translate('forgot_password'),
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialMediaButton('assets/icon_facebook.png', () {}),
              const SizedBox(width: 25),
              _buildSocialMediaButton('assets/icon_google.png', () {})
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
                      _buildTextField(
                          _signUpNameController,
                          _registerNameFocusNode,
                          appLocalizations.translate('name_and_surname'),
                          TextFieldType.NAME_AND_SURNAME,
                          focusRegisterEmailTextField),
                      _buildDivider(),
                      _buildTextField(
                          _signUpEmailController,
                          _registerEmailFocusNode,
                          appLocalizations.translate('email_address'),
                          TextFieldType.EMAIL,
                          focusRegisterPasswordTextField),
                      _buildDivider(),
                      _buildTextField(
                          _signUpPasswordController,
                          _registerPasswordFocusNode,
                          appLocalizations.translate('password'),
                          TextFieldType.PASSWORD,
                          focusRegisterRepeatPasswordTextField),
                      _buildDivider(),
                      _buildTextField(
                          _signUpConfirmPasswordController,
                          _registerRepeatPasswordFocusNode,
                          appLocalizations.translate('repeat_password'),
                          TextFieldType.PASSWORD,
                          unFocusRegisterRepeatPasswordTextField,
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
