import 'package:flutter/material.dart';
import 'package:buddy/services/firebase_firestore_service.dart';

import '../models/user/user_model.dart';
import '../services/service_locator.dart';

class UserInterestsScreen extends StatefulWidget {
  @override
  _UserInterestsScreenState createState() => _UserInterestsScreenState();
}

class _UserInterestsScreenState extends State<UserInterestsScreen> {
  //Get the userProfile
  UserProfile userProfile = locator<UserProfile>();

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
          children: [
            //Buddy
            Text(
              'BUDDY',
              style: theme.textTheme.headline1.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),

            //VIRTUAL SCHOOL GOT BETTER
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'VIRTUAL SCHOOL GOT BETTER',
                style: theme.textTheme.headline5.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            FutureBuilder<List>(
              future: locator<FirestoreService>().fetchInterests(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Expanded(
                  child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
                      itemBuilder: (BuildContext context, int index) {
                        //Check if the user is interested in the current object or not
                        bool isUserInterested = false;
                        if (userProfile.interests != null) {
                          userProfile.interests.forEach((interest) {
                            if (interest == snapshot.data[index]['interest_name']) isUserInterested = true;
                          });
                        }

                        //Return the grid view
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              if (isUserInterested) {
                                //Remove this Interest
                                userProfile.interests.remove(snapshot.data[index]['interest_name']);
                              } else {
                                //Add this Interest
                                if (userProfile.interests == null) userProfile.interests = List();
                                userProfile.interests.add(snapshot.data[index]['interest_name']);
                              }
                            });

                            //Update to the server
                            locator<UserProfile>().interests = userProfile.interests;
                            await locator<FirestoreService>().saveUserProfile();
                          },
                          child: GridTile(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(snapshot.data[index]['interest_image']),
                                isUserInterested
                                    ? Icon(Icons.check_circle, color: Colors.green.withAlpha(200), size: 98)
                                    : Container(width: 0, height: 0),
                              ],
                            ),
                            footer: Text(
                              snapshot.data[index]['interest_name' ?? ''],
                              style: theme.textTheme.headline5.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                );
              },
            ),


            //Enter CTA
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                child: Text('Enter', style: theme.textTheme.headline4.copyWith(color: Colors.white)),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
