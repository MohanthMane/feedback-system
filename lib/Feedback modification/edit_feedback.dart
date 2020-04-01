import 'package:flutter/material.dart';
import 'package:feedback_system/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditFeedback extends StatefulWidget {
  DocumentSnapshot feedback;

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
    );
  }
}
