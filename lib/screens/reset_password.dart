import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/components/CustomTextField.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';

import '../app_localization.dart';
import '../constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  String _errorText = '';

  Widget _buildResetPasswordContent(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(top: 35),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              iconSize: 30,
            ),
          ),
          Image(width: 250.0, height: 191.0, image: AssetImage('assets/logo.png')),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                alignment: Alignment.topCenter,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                child: CustomTextField(
                    controller: emailController,
                    focusNode: emailNode,
                    hintText: appLocalizations.translate('email_address'),
                    type: TextFieldType.EMAIL,
                    onFieldSubmitted: unFocusEmailTextField),
              ),
              _buildConfirmButton(context),
            ],
          ),
        ],
      ),
    );
  }

  void unFocusEmailTextField(String value) => emailNode.unfocus();

  Widget _buildConfirmButton(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(top: 100),
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
            appLocalizations.translate('submit'),
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
        ),
        onPressed: () async {
          String email = emailController.text.trim();
          if (await validInternetConnection(appLocalizations) == false) return;
          if (validEmailAddress(email.toLowerCase(), appLocalizations) == false) return;
          await context.read<AuthenticationService>().sendResetPasswordEmail(email);
          showInSnackBar(appLocalizations.translate('reset_password_mail'));
          emailController.clear();
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => emailNode.unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Constants.START_GRADIENT_COLOR, Constants.END_GRADIENT_COLOR],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
            ),
          ),
          alignment: Alignment.topCenter,
          child: _buildResetPasswordContent(context),
        ),
      ),
    );
  }
}
