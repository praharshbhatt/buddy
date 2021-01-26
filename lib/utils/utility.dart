import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Utility {
  static bool isValidEmail(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (emailValid) {
      return true;
    } else {
      return false;
    }
  }

  //Registration: Password min 6 character, one number, one capital letter, one special character - add complexity
  static bool isValidPassword(String pass) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    bool passValid = RegExp(pattern).hasMatch(pass);
    if (passValid) {
      return true;
    } else {
      return false;
    }
  }

  //Return Alert Dialog Box
  static void showAlertDialog(BuildContext context, String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Return Confirmation Dialog Box
  static Future<bool> showConfirmationDialog(BuildContext context, String title, String body) async {
    // flutter defined function
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  //Returns a pop up dialog with a textformfield
  //Returns a String entered by the user
  static Future<String> showInputDialog(BuildContext context, String title, String body) async {
    // flutter defined function

    TextEditingController textEditingController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Body
              Text(body),

              //Input
              TextField(
                controller: textEditingController,
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(textEditingController.text),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  //Show loading pop up
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: new Text("Loading, please wait..."),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSnackBar(BuildContext context, String msg) async {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  //Show Toast Message
  static void showSnackBarScaffold({@required scaffoldKey, String text, String buttonText, VoidCallback onPressed}) {
    try {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(text),
          action: SnackBarAction(label: buttonText, onPressed: onPressed),
        ),
      );
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  static Future<String> getFilePath(File file) async {
    return basename(file.path);
  }

  // Open next screen
  static Future<Map> changeScreen(BuildContext context, Widget widget) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  // Open next screen clear last one screen
  static Future<dynamic> pushReplacement(BuildContext context, Widget widget) async {
    return await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> push(BuildContext context, Widget widget) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static Future<Map> clearState(BuildContext context, Widget widget) async {
    return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (Route<dynamic> route) => false);
  }

  // Check internet
  static Future<bool> checkInternet() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
