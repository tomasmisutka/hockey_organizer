import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onFieldSubmitted;
  final bool isPasswordType;

  CustomTextField(
      {this.controller, this.focusNode, this.onFieldSubmitted, this.isPasswordType = false});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 3,
            spreadRadius: 2,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction:
                  widget.isPasswordType == true ? TextInputAction.done : TextInputAction.next,
              obscureText: widget.isPasswordType == true ? _isObscureText : false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  widget.isPasswordType == true ? Icons.https_outlined : Icons.email_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                hintText: widget.isPasswordType == true ? 'Password' : 'Email address',
                hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                border: InputBorder.none,
              ),
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
              ),
              validator: (String password) {
                if (password.trim().isEmpty) {
                  return 'Password is required';
                }
                if (password.trim().length < 8) {
                  return 'Password si too short';
                }
                return 'Good';
              },
              onFieldSubmitted: widget.onFieldSubmitted,
            ),
          ),
          Visibility(
            visible: widget.isPasswordType,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isObscureText = !_isObscureText;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
