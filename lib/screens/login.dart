import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hockey_organizer/components/introduction_textfield.dart';
import 'package:hockey_organizer/screens/reset_password.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:hockey_organizer/utils/buble_indicator_painter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../app_localization.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
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

  PageController _pageController = PageController();

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

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerRepeatPasswordController.dispose();

    _loginEmailFocusNode.dispose();
    _loginPasswordFocusNode.dispose();
    _registerNameFocusNode.dispose();
    _registerEmailFocusNode.dispose();
    _registerPasswordFocusNode.dispose();
    _registerRepeatPasswordFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPressTabBarSignInButton() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void _onPressTabBarSignUPButton() {
    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void onPressLogInButton(BuildContext context, AppLocalizations appLocalizations) async {
    String email = _loginEmailController.text.trim();
    if (await checkInternetConnection(appLocalizations) == false) return;
    if (validEmailAddress(email.toLowerCase(), appLocalizations) == false) return;
    startLoading();
    await context
        .read<AuthenticationService>()
        .signIn(
          context,
          email: _loginEmailController.text.trim().toLowerCase(),
          password: _loginPasswordController.text.trim(),
        )
        .then((error) {
      if (!mounted) return;
      setState(() {
        _errorText = error;
      });
      stopLoading();
    });
    if (_errorText != '') {
      showInSnackBar(_errorText);
    }
  }

  void onPressRegisterButton(BuildContext context, AppLocalizations appLocalizations) async {
    String emailAddress = _registerEmailController.text.trim().toLowerCase();
    String password = _registerPasswordController.text.trim();
    if (await checkInternetConnection(appLocalizations) == false) return;
    if (validNameAndSurname(appLocalizations) == false) return;
    if (validEmailAddress(emailAddress.toLowerCase(), appLocalizations) == false) return;
    if (validPassword(appLocalizations) == false) return;
    if (validRepeatPassword(appLocalizations) == false) return;
    startLoading();

    await context
        .read<AuthenticationService>()
        .signUp(
          context,
          displayName: _registerNameController.text.trim(),
          email: emailAddress,
          password: password,
        )
        .then((error) {
      if (!mounted) return;
      setState(() {
        _errorText = error;
      });
      stopLoading();
    });
    if (_errorText != '') {
      showInSnackBar(_errorText);
    }
  }

  void onPressGoogleIcon(AppLocalizations appLocalizations) async {
    if (await checkInternetConnection(appLocalizations) == false) return;
    startLoading();
    await context.read<AuthenticationService>().signInWithGoogle();
    if (!mounted) return;
    stopLoading();
  }

  void onPressFacebookButton(AppLocalizations appLocalizations) async {
    if (await checkInternetConnection(appLocalizations) == false) return;
    startLoading();
    await context.read<AuthenticationService>().signInWithFacebook();
    if (!mounted) return;
    stopLoading();
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

  Future<bool> checkInternetConnection(AppLocalizations appLocalizations) async {
    try {
      final internetAccess = await InternetAddress.lookup('google.com');
      if (internetAccess.isNotEmpty && internetAccess[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      print(e.message);
      setState(() {
        _errorText = appLocalizations.translate('no_internet_connection');
      });
    }
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
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      backgroundColor: Color(0xfff32013),
      duration: Duration(seconds: 3),
    ));
  }

  Widget _menuBar(BuildContext context, AppLocalizations appLocalizations) {
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
                  appLocalizations.translate('existing'),
                  style: _menuTextStyle.copyWith(color: leftTabColor),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onPressTabBarSignUPButton,
                child: Text(appLocalizations.translate('new'),
                    textAlign: TextAlign.center, style: _menuTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textDivider(bool isOnLeftSide) {
    List<Color> leftDividerColors = [Colors.white10, Colors.white];
    List<Color> rightDividerColors = [Colors.white, Colors.white10];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: isOnLeftSide ? leftDividerColors : rightDividerColors,
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      width: 110,
      height: 1.0,
    );
  }

  Widget orTextWithDividers(AppLocalizations appLocalizations) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textDivider(true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(appLocalizations.translate('or'),
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          textDivider(false),
        ],
      ),
    );
  }

  Widget confirmationButton(BuildContext context, String text,
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
              onPressLogInButton(context, appLocalizations);
            } else {
              onPressRegisterButton(context, appLocalizations);
            }
          }),
    );
  }

  Widget signInContent(BuildContext context, AppLocalizations appLocalizations) {
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
                      IntroductionTextField(
                        controller: _loginEmailController,
                        focusNode: _loginEmailFocusNode,
                        hintText: appLocalizations.translate('email_address'),
                        type: TextFieldType.EMAIL,
                        onFieldSubmitted: focusLoginPasswordTextField,
                      ),
                      textFieldDivider(),
                      IntroductionTextField(
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
              confirmationButton(context, 'login'),
            ],
          ),
          const SizedBox(height: 5),
          FlatButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ThemeConsumer(child: ResetPasswordScreen()))),
              child: Text(
                appLocalizations.translate('forgot_password'),
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          orTextWithDividers(appLocalizations),
          const SizedBox(height: 15),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GoogleSignInButton(
                onPressed: () => onPressGoogleIcon(appLocalizations),
                darkMode: true,
                text: appLocalizations.translate('continue_with_google'),
              ),
              const SizedBox(height: 20),
              FacebookSignInButton(
                onPressed: () => onPressFacebookButton(appLocalizations),
                text: appLocalizations.translate('continue_with_facebook'),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget signUpContent(BuildContext context, AppLocalizations appLocalizations) {
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
                      IntroductionTextField(
                          controller: _registerNameController,
                          focusNode: _registerNameFocusNode,
                          hintText: appLocalizations.translate('name_and_surname'),
                          type: TextFieldType.NAME_AND_SURNAME,
                          onFieldSubmitted: focusRegisterEmailTextField),
                      textFieldDivider(),
                      IntroductionTextField(
                          controller: _registerEmailController,
                          focusNode: _registerEmailFocusNode,
                          hintText: appLocalizations.translate('email_address'),
                          type: TextFieldType.EMAIL,
                          onFieldSubmitted: focusRegisterPasswordTextField),
                      textFieldDivider(),
                      IntroductionTextField(
                          controller: _registerPasswordController,
                          focusNode: _registerPasswordFocusNode,
                          hintText: appLocalizations.translate('password'),
                          type: TextFieldType.PASSWORD,
                          onFieldSubmitted: focusRegisterRepeatPasswordTextField),
                      textFieldDivider(),
                      IntroductionTextField(
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
              confirmationButton(context, 'register', isLoginButton: false, margin: 340),
            ],
          ),
        ],
      ),
    );
  }

  Widget textFieldDivider() {
    return Container(width: 250.0, height: 1.0, color: Colors.grey[400]);
  }

  Widget content(BuildContext context, AppLocalizations appLocalizations) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: SpinKitThreeBounce(size: 55, color: Colors.black),
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: GestureDetector(
              onTap: unFocusAllNodes,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 810.0,
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
                    Image(width: 250.0, height: 191.0, image: AssetImage('assets/logo.png')),
                    _menuBar(context, appLocalizations),
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
                              child: signInContent(context, appLocalizations)),
                          ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: signUpContent(context, appLocalizations)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return content(context, appLocalizations);
  }
}
