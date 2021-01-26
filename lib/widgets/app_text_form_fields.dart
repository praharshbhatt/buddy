import 'package:flutter/material.dart';

//This Package contains the widgets for all the buttons used in the app
///This Returns TextBox
class PrimaryTextFormField extends StatelessWidget {
  final String text, hintText, helperText;
  final TextEditingController textEditingController;
  final Icon icon;
  final TextInputType keyboardType;
  final Color textColor, color;
  final int maxLines, minLines;
  final Function(String) onChanged, validator;
  final bool obscure;

  PrimaryTextFormField({
    this.text,
    this.hintText,
    this.helperText,
    this.textEditingController,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.textColor,
    this.color,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,
      controller: textEditingController,
      initialValue: text,
      cursorHeight: 20,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        helperText: helperText ?? '',
        hintText: hintText ?? '',
        contentPadding: EdgeInsets.zero,
        icon: icon ?? Container()
      ),
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscure,
    );
  }
}