import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function() onPressed;

  ActionButton({this.buttonColor = Colors.red, this.buttonText = 'Log out', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
        color: buttonColor,
        elevation: 10,
        child: Text(buttonText, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
