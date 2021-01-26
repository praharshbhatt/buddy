import 'package:flutter/material.dart';

//This Package contains the widgets for all the buttons used in the app

///This Returns the Primary Raised button with Icon
class PrimaryRaisedButton extends StatelessWidget {
  final String text;
  final Widget child;
  final Icon icon;
  final Color textColor, backgroundColor;
  final VoidCallback onPressed;

  PrimaryRaisedButton({
    this.text,
    this.child,
    this.icon,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      icon: icon ?? Container(width: 0, height: 0),
      color: backgroundColor ?? Theme.of(context).buttonColor,
      label: Center(
        child: child ??
            Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ) ??
            Container(),
      ),
      onPressed: onPressed,
    );
  }
}
