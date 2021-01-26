import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:buddy/models/user/user_model.dart';
import 'package:buddy/services/service_locator.dart';

import 'buddy_profile_screen.dart';

class FindBuddyScreen extends StatefulWidget {
  @override
  _FindBuddyScreenState createState() => _FindBuddyScreenState();
}

class _FindBuddyScreenState extends State<FindBuddyScreen> {
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
        child: Column(
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

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('user_interests', arrayContainsAny: locator<UserProfile>().interests)
                  .get()
                  .asStream(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (BuildContext context, int index) {
                      UserProfile buddy = UserProfile.fromMap(snapshot.data.docs[index].data());
                      if (buddy.uid == locator<UserProfile>().uid) return Container();

                      return ListTile(
                        //Profile picture
                        leading: Hero(
                          tag: buddy.uid,
                          child: CircleAvatar(
                            backgroundImage: buddy.profilePictureURL != null
                                ? Image.network(buddy.profilePictureURL).image
                                : Image.asset('assets/icons/icon.png').image,
                          ),
                        ),

                        //Name
                        title: Text(
                          buddy.firstName ?? '' + buddy.lastName ?? '',
                          style: TextStyle(color: Colors.white),
                        ),

                        //Interests
                        subtitle: Text(
                          'Interests: ${buddy.interests}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Colors.white),

                        //Open profile
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BuddyProfileScreen(buddy))),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
