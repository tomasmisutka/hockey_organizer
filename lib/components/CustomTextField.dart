import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onFieldSubmitted;
  final TextFieldType type;
  final String hintText;
  final bool isRepeatingPassword;

  CustomTextField({
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.type = TextFieldType.EMAIL,
    this.hintText,
    this.isRepeatingPassword = false,
  });
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscureText = true;

  Widget _renderPrefixIcon() {
    double _iconSize = 25;
    Color _iconColor = Colors.black;
    if (widget.type == TextFieldType.NAME_AND_SURNAME) {
      return Icon(Icons.person, size: _iconSize, color: _iconColor);
    } else if (widget.type == TextFieldType.EMAIL) {
      return Icon(Icons.email_outlined, size: _iconSize, color: _iconColor);
    }
    return Icon(Icons.https_outlined, size: _iconSize, color: _iconColor);
  }

  Widget _renderSuffixIcon() {
    if (widget.type == TextFieldType.PASSWORD) {
      return IconButton(
          splashColor: Colors.transparent,
          icon:
              Icon(_isObscureText ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined),
          color: Colors.black,
          iconSize: 25,
          onPressed: () {
            setState(() {
              _isObscureText = !_isObscureText;
            });
          });
    }
    return null;
  }

  TextInputAction _renderInputAction() {
    if (widget.type == TextFieldType.PASSWORD && widget.isRepeatingPassword == true) {
      return TextInputAction.done;
    }
    return TextInputAction.next;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        focusNode: widget.focusNode,
        controller: widget.controller,
        textCapitalization: widget.type == TextFieldType.NAME_AND_SURNAME
            ? TextCapitalization.words
            : TextCapitalization.none,
        keyboardType: TextInputType.emailAddress,
        textInputAction: _renderInputAction(),
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        obscureText: widget.type == TextFieldType.PASSWORD ? _isObscureText : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: _renderPrefixIcon(),
          suffixIcon: _renderSuffixIcon(),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 17),
        ),
        cursorColor: Colors.black,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}

enum TextFieldType { EMAIL, PASSWORD, NAME_AND_SURNAME }
