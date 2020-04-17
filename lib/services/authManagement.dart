import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  BuildContext context;
  SharedPreferences _prefs;

  initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Auth(context) {
    this.context = context;
    initialise();
  }

  Future<void> signIn(String _email, String _password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((user) {
          getAdmins(_email).then((docs) {
            if(docs.documents.length > 0) {
              _prefs.setBool("admin", true);
            } else {
              _prefs.setBool("admin", false);
            }
            _prefs.setString("email", _email);
          });
      Navigator.pushReplacementNamed(context, '/homepage');
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
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(message: 'Creating account', progressWidget: CircularProgressIndicator());
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    await Firestore.instance.collection('/users').add({
      'email': email,
      'isadmin': false
    }).then((val) {
      pr.hide();
      _prefs.setString('email', email);
      _prefs.setBool('isadmin', false);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    });
    return user.uid;
  }

  Future<String> getUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      _prefs.setBool('isadmin', null);
      _prefs.setString('email', null);
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/landingpage', (v) => false);
    }).catchError((e) {
      print(e);
    });
  }

  getAdmins(String email) {
    var docs = Firestore.instance
        .collection('/users')
        .where('email', isEqualTo: email)
        .where('isadmin', isEqualTo: true)
        .getDocuments();
    return docs;
  }
}
