import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class CrudMethods {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser() != null;
  }

  // addData, getData, updateData
}