import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:buddy/services/firebase_firestore_service.dart';
import 'package:buddy/services/firebase_storage_service.dart';
import 'package:buddy/utils/utility.dart';

import '../models/user/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/service_locator.dart';
import 'authentication/start_screen.dart';
import 'user_interests_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //Get the Theme data
    ThemeData theme = Theme.of(context);

    //Get the userProfile
    UserProfile userProfile = locator<UserProfile>();

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
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: userProfile != null && userProfile.profilePictureURL != null
                          ? Image.network(userProfile.profilePictureURL).image
                          : Image.asset('assets/icons/icon.png').image,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: MediaQuery.of(context).size.width * 0.3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(radius: 24, backgroundColor: Colors.white),
                      IconButton(
                        icon: Icon(Icons.edit, color: theme.primaryColor, size: 32),
                        onPressed: () async {
                          //Show the dialogbox to upload new photo
                          String newProfilePicURL = await showDialog(
                            context: context,
                            builder: (_) => FirebaseUploadProfilePhotoDialog(
                              'Upload your Photo',
                              'profile_photo',
                              userProfile.profilePictureURL ?? '',
                              'Users/' + userProfile.uid,
                              FileType.image,
                            ),
                          );

                          //Set the new photo
                          if (newProfilePicURL != null) {
                            setState(() {
                              userProfile.profilePictureURL = newProfilePicURL;
                            });
                            locator<UserProfile>().profilePictureURL = newProfilePicURL;
                            await locator<FirestoreService>().saveUserProfile();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //Email
            ListTile(
              title: const Text('Email', style: TextStyle(color: Colors.white)),
              subtitle: Text(userProfile.email ?? 'Not Added', style: TextStyle(color: Colors.white)),
            ),

            //First Name
            ListTile(
              title: const Text('First name', style: TextStyle(color: Colors.white)),
              subtitle: Text(userProfile.firstName ?? 'Not Added', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.edit, color: Colors.white),
              onTap: () async {
                String newName = await Utility.showInputDialog(context, 'Change First Name', 'Enter your new first name');
                if (newName != null) {
                  setState(() {
                    userProfile.firstName = newName;
                  });
                  locator<UserProfile>().firstName = newName;
                  await locator<FirestoreService>().saveUserProfile();
                }
              },
            ),

            //Last Name
            ListTile(
              title: const Text('Last name', style: TextStyle(color: Colors.white)),
              subtitle: Text(userProfile.lastName ?? 'Not Added', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.edit, color: Colors.white),
              onTap: () async {
                String newName = await Utility.showInputDialog(context, 'Change Last Name', 'Enter your new last name');
                if (newName != null) {
                  setState(() {
                    userProfile.lastName = newName;
                  });
                  locator<UserProfile>().lastName = newName;
                  await locator<FirestoreService>().saveUserProfile();
                }
              },
            ),

            //Interests
            ListTile(
              title: const Text('Your Interests', style: TextStyle(color: Colors.white)),
              subtitle: Text(userProfile.interests.toString() ?? 'Not Added', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.edit, color: Colors.white),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserInterestsScreen()));
                setState(() {});
              },
            ),

            //Log out
            ListTile(
              title: const Text('Log out', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.login, color: Colors.white),
              onTap: () {
                //clear the user data
                locator.unregister<UserProfile>();
                locator.registerLazySingleton(() => UserProfile());

                //Sign out
                locator<AuthService>().signOut();
                locator.unregister<AuthService>();
                locator.registerLazySingleton(() => AuthService());

                //Go to the Start screen
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => StartScreen()));
                // Navigator.of(context)
                //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StartScreen()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
