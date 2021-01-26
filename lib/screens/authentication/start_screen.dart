import 'package:flutter/material.dart';
import 'package:buddy/screens/authentication/login_screen.dart';
import 'package:buddy/screens/authentication/signup_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //Get the Theme data
    ThemeData theme = Theme.of(context);

    //Screen Content
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [const Color(0xFF2C97E4), const Color(0xFF021756)],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.5, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),

          //Body
          child: ListView(
            children: [
              //Already a user?
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Already a user?',
                    style: theme.textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                },
              ),

              Divider(color: Colors.white),

              //Illustration
              Image.asset('assets/images/illustration 1.png'),

              //Buddy
              Text(
                'BUDDY',
                style: theme.textTheme.headline1.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              //VIRTUAL SCHOOL GOT BETTER
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'VIRTUAL SCHOOL GOT BETTER',
                  style: theme.textTheme.headline5.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

              //Get Started
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      child: Text('GET STARTED', style: theme.textTheme.headline4.copyWith(color: Colors.white)),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      borderSide: BorderSide(color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
