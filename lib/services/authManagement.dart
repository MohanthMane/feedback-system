import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  BuildContext context;

  Auth(this.context);

  Future<void> signIn(String _email, String _password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        tittle: 'Error',
        desc: "Recheck your network connection or credentials",
        animType: AnimType.BOTTOMSLIDE,
      ).show();
    });
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/landingpage', (v) => false);
    }).catchError((e) {
      print(e);
    });
  }

  getAdmins(String email) {
    var docs = Firestore.instance.collection('/users').where('email',isEqualTo:email).where('isadmin',isEqualTo: true).getDocuments();
    return docs;
  }
}
