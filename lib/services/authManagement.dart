import 'package:feedback_system/public/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  BuildContext context;

  Auth(this.context);

  Future<void> signIn(String _email,String _password) async {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email,
      password: _password
    ).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
      DialogPopUp dialog = new DialogPopUp(
          title: 'Error',
          content: "Couldn't sign in with above credentials",
          context: context
        );
      dialog.dialogPopup();
    });
  }

  Future<String> signUp(String email,String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email,password: password)).user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}