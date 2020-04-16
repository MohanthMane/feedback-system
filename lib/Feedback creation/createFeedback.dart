import 'package:feedback_system/Feedback%20creation/crud.dart';
import 'package:feedback_system/models/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MetricType { 
  Satisfaction, 
  GoalCompletionRate, 
  EffortScore, 
  SmileyRating 
}

class Question {
  String questionData = "";
  MetricType metricType = MetricType.GoalCompletionRate;
}

class QuestionDialog extends StatefulWidget {
  final String questionAction;
  final Question question;

  QuestionDialog(this.questionAction, this.question);

  @override
  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  // MetricType _metricType = widget.question.metricType;
  MetricType _metricType = MetricType.GoalCompletionRate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questionAction),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                initialValue: widget.question.questionData,
                decoration: InputDecoration(hintText: 'Question'),
                onChanged: (text) {
                  widget.question.questionData = text;
                },
              ),
              Radio(
                value: MetricType.EffortScore,
                groupValue: _metricType,
                onChanged: (MetricType value) {
                  setState(() {
                    print(value);
                    _metricType = value;
                  });
                },
              ),
              Image.asset("assets/effort.png"),
              Radio(
                value: MetricType.SmileyRating,
                groupValue: _metricType,
                onChanged: (MetricType value) {
                  setState(() {
                    print(value);
                    _metricType = value;
                  });
                },
              ),
              Image.asset("assets/smiley.png"),
              Radio(
                value: MetricType.GoalCompletionRate,
                groupValue: _metricType,
                onChanged: (MetricType value) {
                  print(value);
                  setState(() {
                    _metricType = value;
                  });
                },
              ),
              Image.asset("assets/goalcompletion.png"),
              Radio(
                value: MetricType.Satisfaction,
                groupValue: _metricType,
                onChanged: (MetricType value) {
                  print(value);
                  setState(() {
                    _metricType = value;
                  });
                },
              ),
              Image.asset("assets/satisfaction.png"),
              Container(
                height: 50,
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'ADD',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (widget.question.questionData.length != 0) {
                    widget.question.metricType = _metricType;
                    //print(widget.question);
                    Navigator.pop(context, widget.question);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateFeedback extends StatefulWidget {
  final String name, host, type;

  CreateFeedback({this.name, this.host, this.type});

  @override
  _CreateFeedbackState createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> {
  List<Question> questionsList = List<Question>();
  final String content = "Can't add empty question";
  final String title = "Error";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create feedback'),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              dynamic questionReference = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuestionDialog("Create Question", Question()),
                  ));
              if (questionReference != null) {
                questionsList.add(questionReference);
              }
            },
          )
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(height: 1.0, color: Colors.grey),
        itemCount: questionsList.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(questionsList[index].questionData),
              onDismissed: (direction) {
                setState(() {
                  questionsList.removeAt(index);
                });
                Scaffold.of(context).showSnackBar((SnackBar(
                  content: Text('Question deleted'),
                )));
              },
              background: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              child: ListTile(
                leading: Text(
                  (index + 1).toString() + ")",
                  style: TextStyle(fontSize: 15),
                ),
                title: Text(questionsList[index].questionData),
                trailing: Text(questionsList[index].metricType.toString()),
                onTap: () {
                  print('Here on Tap');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionDialog(
                            "Edit Question", questionsList[index])),
                  );
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
            onPressed: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              String email = _prefs.getString("email");
              FeedbackModel feedback = new FeedbackModel(
                  //Modify Here
                  questionsList,
                  widget.type,
                  widget.name,
                  widget.host,
                  email);
              CrudMethods().postFeedback(context, feedback);
            },
          ),
        )
      ],
    );
  }
}
