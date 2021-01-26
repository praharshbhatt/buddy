import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double width = 100, height = 100;

  @override
  void initState() {
    //Animation
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Get the Theme data
    ThemeData theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        //Background
        Image.asset(
          'assets/images/illustration 1.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),

        //Add Blur Layer
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.4))),
        ),

        //Logo
        Align(
          child: ScaleTransition(
            // ignore: always_specify_types
            scale: Tween(begin: 0.75, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
            child: AppLogo(height: 80, width: 80),
          ),
        ),

        //App Name
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).size.height * 0.5 - 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Buddy',
              style: theme.textTheme.headline4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
