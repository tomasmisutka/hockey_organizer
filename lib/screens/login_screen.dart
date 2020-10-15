import 'package:flutter/material.dart';
import 'package:hockey_organizer/components/CustomTextField.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _loginController;
  TextEditingController _passwordController;
  FocusNode _loginNode;
  FocusNode _passwordNode;
  bool isPasswordSecure = true;

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

  Widget _buildManualLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSeparator(),
        CustomTextField(
          controller: _loginController,
          focusNode: _loginNode,
          onFieldSubmitted: focusPasswordTextField,
        ),
        _buildSeparator(),
        CustomTextField(
          controller: _passwordController,
          focusNode: _passwordNode,
          onFieldSubmitted: unFocusPasswordTextField,
          isPasswordType: true,
        ),
        _buildSeparator(),
        RaisedButton(
          elevation: 15,
          color: Colors.redAccent,
          onPressed: () {},
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.black54,
              child: Text('Sign in', style: TextStyle(fontSize: 20))),
        ),
      ],
    );
  }

  Widget _buildThirdPartyLoginButton(String imagePath, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: RaisedButton(
        elevation: 15,
        color: Colors.white,
        onPressed: () {},
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(imagePath, height: 25, width: 25),
            Text(text, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPartyLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildThirdPartyLoginButton('assets/icon_google.png', 'Google'),
        _buildSeparator(),
        _buildThirdPartyLoginButton('assets/icon_facebook.png', 'Facebook'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _loginNode.unfocus();
          _passwordNode.unfocus();
        },
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 45),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                ),
                _buildManualLogin(),
                const SizedBox(height: 35),
                _buildThirdPartyLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
