import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width, height;

  AppLogo({this.width, this.height});

  @override
  Widget build(BuildContext context) => width != null && height != null
      ? Image.asset(
          'assets/icons/icon.png',
          width: width,
          height: height,
        )
      : Image.asset('assets/icons/icon.png');
}
