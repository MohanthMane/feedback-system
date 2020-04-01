import 'package:feedback_system/Feedback%20creation/crud.dart';
import 'package:feedback_system/models/feedback_model.dart';
import 'package:flutter/material.dart';

class CreateFeedback extends StatefulWidget {
  final String name, host;
  final List<bool> sections;

  CreateFeedback({this.name, this.host, this.sections});

  @override
  _CreateFeedbackState createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> {
  List<String> questions = new List<String>();
  final String content = "Can't add empty question";
  final String title = "Error";
  String question = "";

  _questionDialog(BuildContext context, String previousText,int index,String title) async {
    question = previousText;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
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
                      if(previousText != "")
                        questions.removeAt(index);
                      questions.insert(index,question);
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
            child: Icon(Icons.add,color: Colors.white,),
            onPressed: () {
              _questionDialog(context, "",questions.length,'Question');
            },
          )
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(height: 1.0, color: Colors.grey),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(questions[index]),
              onDismissed: (direction) {
                setState(() {
                  questions.removeAt(index);
                });
                Scaffold.of(context).showSnackBar((SnackBar(
                  content: Text('Question deleted'),
                )));
              },
              background: Container(
                color: Colors.red, 
                child: Center(
                  child: Text('Delete',
                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              child: ListTile(
                leading: Text(
                  (index + 1).toString() + ")",
                  style: TextStyle(fontSize: 15),
                ),
                title: Text(questions[index]),
                onTap: () {
                  print('Here on Tap');
                  _questionDialog(context, questions[index],index,'Edit Question');
                },
              ));
        },
      ),
      persistentFooterButtons: <Widget>[
        SizedBox(
          width: width,
          child: RaisedButton(
            color: Colors.blue,
            child: Text('Post'),
            onPressed: () {
              FeedbackModel feedback = new FeedbackModel(
                  questions, widget.sections, widget.name, widget.host);
              CrudMethods().postFeedback(context, feedback);
            },
          ),
        )
      ],
    );
  }
}
