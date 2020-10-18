import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

import '../contants.dart';

class LoginOrRegistrationScreen extends StatelessWidget {
  final bool isRegistrationType;

  LoginOrRegistrationScreen({this.isRegistrationType = false});

  Widget _renderAppBarText(BuildContext context) {
    AppLocalizations _appLocalizations = AppLocalizations.of(context);
    TextStyle _appBarStyle =
        TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic);
    if (isRegistrationType == false) {
      return Text(_appLocalizations.translate('login'), style: _appBarStyle);
    }
    return Text(_appLocalizations.translate('registration'), style: _appBarStyle);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.LOGIN_BG_COLOR,
        appBar: AppBar(
          title: _renderAppBarText(context),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Center(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          color: Colors.white,
          child: Text('test'),
        )),
      ),
    );
  }
}
