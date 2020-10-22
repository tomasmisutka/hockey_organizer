import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

import '../contants.dart';

class VerificationScreen extends StatelessWidget {
  Widget _buildVerificationDescription(BuildContext context) {
    TextStyle _textStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, height: 1.2);

    AppLocalizations appLocalizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appLocalizations.translate('verification_screen_description'), style: _textStyle),
          const SizedBox(height: 15),
          Text(appLocalizations.translate('best_regards'), style: _textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.LOGIN_BG_COLOR,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(child: _buildVerificationDescription(context)),
      ),
    );
  }
}
