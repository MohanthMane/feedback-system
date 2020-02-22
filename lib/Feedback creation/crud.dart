import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrudMethods {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser() != null;
  }

  // addData, getData, updateData
  postFeedback(context, feedback) {
    ProgressDialog pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: 'Hosting', progressWidget: CircularProgressIndicator());
    pr.show();
    Firestore.instance.collection('feedbacks').add({
      'name': feedback.name,
      'host': feedback.host,
      'sections': feedback.sections,
      'questions': feedback.questions,
      'scores': feedback.scores,
      'remarks': feedback.remarks,
      'attended': feedback.attended,
      'status': feedback.status,
    }).then((doc) {
      pr.hide();
      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'Success',
          desc: 'Feedback is now open',
          dismissOnTouchOutside: false,
          btnOkOnPress: () {
            Navigator.of(context, rootNavigator: false).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/homepage', (r) => false);
          }).show();
    }).catchError((e) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'Error',
          desc: 'Failed to upload the data',
          dismissOnTouchOutside: false,
          btnOkOnPress: () {
            Navigator.of(context, rootNavigator: false).pop();
          }).show();
    });
  }
}
