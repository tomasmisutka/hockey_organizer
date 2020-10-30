import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/contants.dart';

class VerificationScreen extends StatelessWidget {
  Widget _buildVerificationDescription(BuildContext context) {
    TextStyle _textStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, height: 1.2);

    AppLocalizations appLocalizations = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 75),
        Image(width: 250.0, height: 191.0, image: AssetImage('assets/hockey.png')),
        const SizedBox(height: 20),
        Container(
          width: 300,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appLocalizations.translate('verification_screen_description'),
                  style: _textStyle),
              const SizedBox(height: 15),
              Text(appLocalizations.translate('best_regards'),
                  style: _textStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: _buildVerificationDescription(context),
      ),
    );
  }
}
