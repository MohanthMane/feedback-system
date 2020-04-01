import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/Feedback%20creation/GenerateScreen.dart';
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
    pr.style(message: 'Generating QR Code', progressWidget: CircularProgressIndicator());
    pr.show();
    Firestore.instance.collection('feedbacks').add({
      'name': feedback.name,
      'host': feedback.host,
      'host_id': feedback.host_id,
      'type': feedback.type,
      'questions': feedback.questions,
      'scores': feedback.scores,
      'remarks': feedback.remarks,
      'attended': feedback.attended,
      'status': feedback.status
    }).then((doc) {
      pr.hide();
      print(doc.documentID);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateScreen(docID: doc.documentID)
        )
      );
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