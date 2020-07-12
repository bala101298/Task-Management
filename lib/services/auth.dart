import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasker/services/database.dart';

final _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseUser signeduser;
FirebaseMessaging fcm = FirebaseMessaging();
String token;

class User {
  final String uid;

  User({this.uid});
}

class Authentication {
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_manualuser);
  }

  User _manualuser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount _googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleSignInAuthentication =
          await _googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleSignInAuthentication.idToken,
          accessToken: _googleSignInAuthentication.accessToken);
      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);
      print(result);
      if (result != null) {
        getUser();
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {}
  }

  getUser() async {
    try {
      await fcm.getToken().then((value) {
        token = value;
      });
      final user = await _firebaseAuth.currentUser();
      print("current user ${user.uid}");
      if (user != null) {
        signeduser = user;
        print("Signeduser uid ${signeduser.uid}");
        Database(uid: signeduser.uid).updateUserData(
          displayName: signeduser.displayName,
          email: signeduser.email,
          photoUrl: signeduser.photoUrl,
          token: token,
        );
        return _manualuser(signeduser);
      } else
        return null;
    } catch (e) {}
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  String userUid() {
    return signeduser.uid;
  }
}
