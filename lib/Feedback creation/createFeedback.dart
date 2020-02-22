import 'package:feedback_system/Feedback%20creation/crud.dart';
import 'package:feedback_system/Feedback%20creation/listElement.dart';
import 'package:feedback_system/models/feedback_model.dart';
import 'package:flutter/material.dart';

class CreateFeedback extends StatefulWidget {
  final String name, host;
  final List<bool> sections;

  CreateFeedback({this.name,this.host,this.sections});

  @override
  _CreateFeedbackState createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> {
  List<String> questions = new List<String>();
  final String content = "Can't add empty question";
  final String title = "Error";
  String question = "";

  _questionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Question'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Question'),
              onChanged: (text) {
                question = text;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ADD'),
                onPressed: () {
                  print(question.length);
                  if (question.length != 0) {
                    setState(() {
                      questions.add(question);
                      question = "";
                    });
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.add),
            onPressed: () {
              _questionDialog(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListElement(index: index, question: questions[index]));
        },
      ),
      persistentFooterButtons: <Widget>[
        SizedBox(
          width: width,
          child: RaisedButton(
            color: Colors.blue,
            child: Text('Post'),
            onPressed: () {
              FeedbackModel feedback = new FeedbackModel(questions,widget.sections,widget.name,widget.host);
              CrudMethods().postFeedback(context,feedback);
            },
          ),
        )
      ],
    );
  }
}
