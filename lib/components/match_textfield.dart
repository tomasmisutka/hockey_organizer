import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

class MatchTextField extends StatelessWidget {
  final IconData iconData;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final String labelText;
  final String hintText;

  MatchTextField(this.controller, this.focusNode, this.iconData, this.labelText, this.hintText,
      {this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Row(
      children: [
        Icon(iconData, color: Colors.black, size: 25),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(fontWeight: FontWeight.bold),
            textInputAction: TextInputAction.done,
            keyboardType: inputType,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Theme.of(context).primaryColor)),
                labelText: appLocalizations.translate(labelText),
                hintText: appLocalizations.translate(hintText)),
          ),
        ),
      ],
    );
  }
}
