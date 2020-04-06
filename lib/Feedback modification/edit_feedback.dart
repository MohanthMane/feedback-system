import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditFeedback extends StatefulWidget {
  final DocumentSnapshot feedback;

  EditFeedback({this.feedback});

  @override
  _EditFeedbackState createState() => _EditFeedbackState();
}

class _EditFeedbackState extends State<EditFeedback> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    (index + 1).toString() + ")",
                    style: TextStyle(fontSize: 15),
                  ),
                  title: Text(widget.feedback.data['questions'][index]),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(height: 1.0, color: Colors.grey),
              itemCount: widget.feedback.data['questions'].length)),
      persistentFooterButtons: <Widget>[
        SizedBox(
          width: width,
          child: RaisedButton(
            color: Colors.blue,
            child: Text('View statistics'),
            onPressed: () {
              print('Under development');
            },
          ),
        )
      ],
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        tooltip: 'End feedback',
        backgroundColor: Colors.white24,
        child: Icon(
          Icons.cancel,
          size: 50,
          color: Colors.blue,
        ),
        onPressed: endFeedback,
      ),
    );
  }

  endFeedback() async {
    ProgressDialog pr = new ProgressDialog(context, isDismissible: false);
    pr.style(
        message: 'Closing feedback',
        progressWidget: CircularProgressIndicator());
    pr.show();
    await Firestore.instance
        .collection('/feedbacks')
        .document(widget.feedback.documentID)
        .updateData({'status': 'close'}).then((val) {
      pr.hide();
    });
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Success',
        desc: 'Feedback closed successfully',
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/homepage', (r) => false);
        }).show();
  }
}
