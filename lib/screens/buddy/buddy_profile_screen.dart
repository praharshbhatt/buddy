import 'package:flutter/material.dart';

import '../../models/user/user_model.dart';

class BuddyProfileScreen extends StatefulWidget {
  final UserProfile buddy;

  BuddyProfileScreen(this.buddy);

  @override
  _BuddyProfileScreenState createState() => _BuddyProfileScreenState();
}

class _BuddyProfileScreenState extends State<BuddyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //Get the Theme data
    ThemeData theme = Theme.of(context);

    return Scaffold(
      //Body
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
        child: ListView(
          children: <Widget>[
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

            //Profile photo
            Hero(
              tag: widget.buddy.uid,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: widget.buddy != null && widget.buddy.profilePictureURL != null
                      ? Image.network(widget.buddy.profilePictureURL).image
                      : Image.asset('assets/icons/icon.png').image,
                ),
              ),
            ),

            //Email
            ListTile(
              title: const Text('Email', style: TextStyle(color: Colors.white)),
              subtitle: Text(widget.buddy.email ?? 'Not Added', style: TextStyle(color: Colors.white)),
            ),

            //First Name
            ListTile(
              title: const Text('First name', style: TextStyle(color: Colors.white)),
              subtitle: Text(widget.buddy.firstName ?? 'Not Added', style: TextStyle(color: Colors.white)),
            ),

            //Last Name
            ListTile(
              title: const Text('Last name', style: TextStyle(color: Colors.white)),
              subtitle: Text(widget.buddy.lastName ?? 'Not Added', style: TextStyle(color: Colors.white)),
            ),

            //Interests
            ListTile(
              title: const Text('Your Interests', style: TextStyle(color: Colors.white)),
              subtitle: Text(widget.buddy.interests.toString() ?? 'Not Added', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
