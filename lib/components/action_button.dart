import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

class ActionButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function() onPressed;

  ActionButton({this.buttonColor = Colors.red, this.buttonText = 'log_out', this.onPressed});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      color: buttonColor,
      elevation: 7,
      child: Text(appLocalizations.translate(buttonText),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}
