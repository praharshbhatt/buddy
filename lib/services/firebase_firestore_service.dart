import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user/user_model.dart';
import 'service_locator.dart';

class FirestoreService {
  //Gets the user's UID
  Future<String> getUserUID(String email) async {
    //Get the user id from the database
    QuerySnapshot qsUser = await FirebaseFirestore.instance.collection('Users').where('user_email', isEqualTo: email).get();
    if (qsUser.size > 0) return qsUser.docs[0].data()['user_uid'];

    return null;
  }

  ///Gets the userProfile
  ///If calling for the first time, please make sure to pass either [userID] or the [userEmail] for this user
  Future<bool> fetchUserProfile({String userId, String userEmail}) async {
    bool retValue;

    //Check if we have the userId
    UserProfile userProfile = locator<UserProfile>();
    userId ??= userProfile.uid ?? await getUserUID(userEmail ?? userProfile.email);
    if (userId == null) return false;

    //Get the user profile data
    FirebaseFirestore.instance.collection('Users').doc(userId).snapshots().listen((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot != null) {
        print('Updated user data:\n' + documentSnapshot.data().toString());

        //Update the values
        locator.unregister<UserProfile>();
        locator.registerLazySingleton(() => UserProfile.fromMap(documentSnapshot.data()));

        //Make the return value true
        retValue = true;
      }
    });

    while (retValue == null) {
      // ignore: always_specify_types
      await Future.delayed(const Duration(seconds: 1));
    }
    return retValue;
  }

  ///Updates the userProfile
  ///If calling for the first time, please make sure to pass either [userID] or the [userEmail] for this user
  Future<void> saveUserProfile() async {
    //Get the user profile data
    UserProfile userProfile = locator<UserProfile>();
    await FirebaseFirestore.instance.collection('Users').doc(userProfile.uid).set(userProfile.toMap());
    return;
  }

  ///All Defined Interests
  ///
  ///
  ///
  ///
  ///Gets User's Added Recipes
  ///Only call this if logged in
  ///Retrieves the user uid from locator
  Future<List> fetchInterests() async {
    List interests = new List();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Interests').get();

    querySnapshot.docs.forEach((interest) => interests.add(interest.data()));

    return interests;
  }
}
