import 'package:flutter/material.dart';
import 'package:buddy/screens/profile_screen.dart';

import 'buddy/find_buddy_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
          child: Column(
            children: [

              //Buddy
              Hero(
                tag: 'BUDDY',
                child: Text(
                  'BUDDY',
                  style: theme.textTheme.headline1.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

              //VIRTUAL SCHOOL GOT BETTER
              Hero(
                tag: 'VIRTUAL SCHOOL GOT BETTER',
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'VIRTUAL SCHOOL GOT BETTER',
                    style: theme.textTheme.headline5.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              OutlineButton(
                child: Text('FIND BUDDY', style: theme.textTheme.headline4.copyWith(color: Colors.white)),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FindBuddyScreen()));
                },
              ),

              //Illustration
              Image.asset('assets/images/illustration 1.png'),

              OutlineButton(
                child: Text('PROFILE', style: theme.textTheme.headline4.copyWith(color: Colors.white)),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
