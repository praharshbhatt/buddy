import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/authentication/start_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/firebase_auth_service.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase
  await Firebase.initializeApp();

  //GetIt
  setupLocator();

  runApp(BuddyApp());
}

class BuddyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      //Title
      title: 'Buddy',

      //Theme
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        accentColor: Colors.blue,
        canvasColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.blueAccent,

        //Card Theme
        cardColor: Colors.white,
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 4,
          margin: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),

        //Button
        buttonColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minWidth: 100,
          height: 50,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(10),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          ),
        ),

        disabledColor: Colors.white60,

        //Default font family
        fontFamily: 'Helvetica Neue',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: const TextTheme(
        //   caption: TextStyle(fontFamily: 'Comfortaa'),
        //   bodyText2: TextStyle(fontFamily: 'Comfortaa'),
        //   bodyText1: TextStyle(fontFamily: 'Comfortaa'),
        //   headline5: TextStyle(fontFamily: 'Comfortaa'),
        //   headline4: TextStyle(fontFamily: 'Comfortaa'),
        //   headline3: TextStyle(fontFamily: 'Comfortaa'),
        //   headline2: TextStyle(fontFamily: 'Comfortaa'),
        //   headline1: TextStyle(fontFamily: 'Comfortaa'),
        // ),
      ),

      //Hide the debug banner
      debugShowCheckedModeBanner: false,

      //Home
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: AuthService.IsSignedIn(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData == false) return SplashScreen();

            if (snapshot.data) {
              //Logged in
              return HomeScreen();
            } else {
              //Not Logged in
              return StartScreen();
            }
          },
        ),
      ),
    );
  }
}
