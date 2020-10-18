import 'package:flutter/material.dart';
import 'package:hockey_organizer/screens/login_or_registration_screen.dart';

import '../app_localization.dart';
import '../contants.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController _loginController;
  TextEditingController _passwordController;
  FocusNode _loginNode;
  FocusNode _passwordNode;

  @override
  void initState() {
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _loginNode = FocusNode();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _loginNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void unFocusPasswordTextField(String value) => _passwordNode.unfocus();

  void focusPasswordTextField(String value) => _passwordNode.requestFocus();

  Widget _buildSeparator() => const SizedBox(height: 15);

  // Widget _buildManualLogin(BuildContext context, AppLocalizations appLocalizations) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       _buildSeparator(),
  //       CustomTextField(
  //         controller: _loginController,
  //         focusNode: _loginNode,
  //         onFieldSubmitted: focusPasswordTextField,
  //       ),
  //       _buildSeparator(),
  //       CustomTextField(
  //         controller: _passwordController,
  //         focusNode: _passwordNode,
  //         onFieldSubmitted: unFocusPasswordTextField,
  //         isPasswordType: true,
  //       ),
  //       _buildSeparator(),
  //       RaisedButton(
  //         elevation: 15,
  //         color: Colors.redAccent,
  //         onPressed: () {
  //           context.read<AuthenticationService>().signIn(
  //                 email: _loginController.text.trim(),
  //                 password: _passwordController.text.trim(),
  //               );
  //         },
  //         padding: EdgeInsets.symmetric(vertical: 15),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         child: Shimmer.fromColors(
  //             baseColor: Colors.white,
  //             highlightColor: Colors.black54,
  //             child: Text(
  //               appLocalizations.translate('sign_in'),
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
  //             )),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildButton(String imagePath, String text, _ButtonType _buttonType, Function onPress) {
    Color borderColor;
    switch (_buttonType) {
      case _ButtonType.mail:
        borderColor = Constants.MAIL_COLOR;
        break;
      case _ButtonType.google:
        borderColor = Constants.GOOGLE_COLOR;
        break;
      case _ButtonType.facebook:
        borderColor = Constants.FACEBOOK_COLOR;
        break;
      default:
        borderColor = Colors.transparent;
    }
    return RaisedButton(
      elevation: 12,
      color: Colors.white,
      onPressed: onPress,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 3, color: borderColor)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(imagePath, height: 25, width: 25),
          Text(text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: borderColor)),
        ],
      ),
    );
  }

  void _onPressEmailButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginOrRegistrationScreen()));
  }

  void _onPressGoogleButton() {}
  void _onPressFacebookButton() {}

  Widget _buildLoginButtons() {
    return Column(
      children: [
        _buildButton('assets/icon_mail.png', 'Email', _ButtonType.mail, _onPressEmailButton),
        _buildSeparator(),
        _buildButton('assets/icon_google.png', 'Google', _ButtonType.google, _onPressGoogleButton),
        _buildSeparator(),
        _buildButton(
            'assets/icon_facebook.png', 'Facebook', _ButtonType.facebook, _onPressFacebookButton),
      ],
    );
  }

  Widget _buildDivider() {
    double _dividerIndent = 13;
    return Expanded(
        child: Divider(
      color: Colors.black.withOpacity(0.8),
      thickness: 2,
      indent: _dividerIndent,
      endIndent: _dividerIndent,
    ));
  }

  Widget _buildUserIconWithDividers() {
    return Row(
      children: [
        _buildDivider(),
        Image.asset('assets/icon_user.png',
            height: 65, width: 65, color: Colors.black.withOpacity(0.8)),
        _buildDivider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations _appLocalizations = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.LOGIN_BG_COLOR,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            _appLocalizations.translate('login'),
            style: TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic),
          ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserIconWithDividers(),
                _buildSeparator(),
                _buildLoginButtons(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _appLocalizations.translate('have_not_account'),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginOrRegistrationScreen(isRegistrationType: true)));
                      },
                      child: Text(
                        _appLocalizations.translate('sign_up'),
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ButtonType {
  google,
  facebook,
  mail,
}
