import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buddy/screens/authentication/signup_screen.dart';
import 'package:buddy/widgets/app_text_form_fields.dart';

import '../../models/user/user_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_firestore_service.dart';
import '../../services/service_locator.dart';
import '../../utils/utility.dart';
import '../../widgets/app_buttons.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  TextEditingController tecEmail = new TextEditingController(), tecPassword = new TextEditingController();

  //For
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    tecEmail.dispose();
    tecPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Get the Theme data
    ThemeData theme = Theme.of(context);

    //Screen Content
    return Scaffold(
      key: scaffoldKey,
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
            //Already a user?
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('New user? Create', style: theme.textTheme.headline5, textAlign: TextAlign.center),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
              },
            ),

            Divider(color: Colors.white),

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

            //===========LOGIN===========
            //Email / password login
            Column(
              children: [
                //Email
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: PrimaryTextFormField(
                    textEditingController: tecEmail,
                    hintText: 'Email',
                    icon: Icon(Icons.email, size: 32),
                  ),
                ),

                //Password
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: PrimaryTextFormField(
                    textEditingController: tecPassword,
                    hintText: 'Password',
                    icon: Icon(Icons.lock, size: 32),
                    keyboardType: TextInputType.visiblePassword,
                    obscure: true,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Forgot Password', style: TextStyle(color: Colors.white)),
                      ),
                      onTap: () async {
                        await EmailAuthService().resetAccountPassword(tecPassword.text);
                        Utility.showSnackBarScaffold(scaffoldKey: scaffoldKey, text: 'Verification email sent.\nPlease check your email.');
                      },
                    ),
                  ],
                ),

                //Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PrimaryRaisedButton(
                      onPressed: () async {
                        if (tecEmail.text == null || tecEmail.text == '' || tecPassword.text == null || tecPassword.text == '') {
                          Utility.showSnackBarScaffold(scaffoldKey: scaffoldKey, text: 'Please enter all your details');
                          return;
                        }

                        User user = (await EmailAuthService().signIn(tecEmail.text, tecPassword.text));
                        if (user != null) {
                          //Show Loading
                          Utility.showLoading(context);

                          //Get the user data from firestore
                          await locator<FirestoreService>().fetchUserProfile(userEmail: user.email);

                          //New user, upload data
                          if (locator<UserProfile>() == null || !locator<UserProfile>().isLoggedIn()) {
                            locator.unregister<UserProfile>();
                            locator.registerLazySingleton(
                              () => UserProfile(
                                email: user.email,
                                uid: user.uid,
                                firstName: user.displayName.split(' ').first ?? '',
                                lastName: user.displayName.split(' ').last ?? '',
                                profilePictureURL: user.photoURL ?? '',
                              ),
                            );
                            await locator<FirestoreService>().saveUserProfile();
                          }

                          //Stop loading
                          Navigator.of(context).pop(false);

                          //Navigate to home screen
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                        }
                      },
                      backgroundColor: Colors.white,
                      text: 'Login'.toUpperCase(),
                      textColor: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30),

            Text(
              '-- OR --',
              style: theme.textTheme.headline5.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),

            //Google Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PrimaryRaisedButton(
                  onPressed: () async {
                    User user = (await GoogleAuthService().signIn());
                    if (user != null) {
                      //Show Loading
                      Utility.showLoading(context);

                      //Get the user data from firestore
                      await locator<FirestoreService>().fetchUserProfile(userEmail: user.email);

                      //New user, upload data
                      if (locator<UserProfile>() == null || !locator<UserProfile>().isLoggedIn()) {
                        locator.unregister<UserProfile>();
                        locator.registerLazySingleton(
                          () => UserProfile(
                            email: user.email,
                            uid: user.uid,
                            firstName: user.displayName.split(' ').first ?? '',
                            lastName: user.displayName.split(' ').last ?? '',
                            profilePictureURL: user.photoURL,
                          ),
                        );
                        await locator<FirestoreService>().saveUserProfile();
                      }

                      //Stop loading
                      Navigator.of(context).pop(false);

                      //Navigate to home screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                    }
                  },
                  backgroundColor: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/google_logo.png', width: 30, height: 30),
                      ),
                      Text(
                        'Login With Google'.toUpperCase(),
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
