import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buddy/services/service_locator.dart';

import 'firebase_firestore_service.dart';

///Authentication Base functions skeleton
abstract class BaseAuth {
  Future<User> signIn();

  Future<User> signUp();
}

///Authentication User object function calls
class AuthService {
  //Checks if the user has signed in
  static Future<bool> IsSignedIn() async {
    bool blIsSignedIn = false;
    //For mobile
    if (FirebaseAuth.instance != null) {
      if (FirebaseAuth.instance.currentUser != null) {
        //User is already logged in

        //Fetch the Userdata
        blIsSignedIn =  await locator<FirestoreService>().fetchUserProfile();
      } else {
        blIsSignedIn = false;
      }
    } else {
      blIsSignedIn = false;
    }

    return blIsSignedIn;
  }

  User getCurrentUser() => FirebaseAuth.instance.currentUser;

  Future<void> signOut() async => FirebaseAuth.instance.signOut();
}

///Email Auth
class EmailAuthService {
  Future<User> signIn(String email, String password) async {
    try {
      UserCredential authRes = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (authRes != null && authRes.user != null) User user = authRes.user;
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmailVerification() async => FirebaseAuth.instance.currentUser.sendEmailVerification();

  Future<bool> isEmailVerified() async => FirebaseAuth.instance.currentUser.emailVerified;

  Future<User> signUp(String email, String password) async {
    try {
      return (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
    } on Exception {
      return null;
    }
  }

  Future<void> resetAccountPassword(String email) async => await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

///Google Auth
class GoogleAuthService with AuthService implements BaseAuth {
  @override
  Future<User> signIn() async {
    // Step 1
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //return user object
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  @override
  Future<User> signUp() async => signIn();
}
