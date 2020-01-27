import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser() != null;
  }

  // addData, getData, updateData
}