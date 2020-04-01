import 'package:feedback_system/Feedback%20creation/createFeedback.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class NamingFeedback extends StatefulWidget {
  @override
  _NamingFeedbackState createState() => _NamingFeedbackState();
}

class _NamingFeedbackState extends State<NamingFeedback> {
  final formKey = new GlobalKey<FormState>();
  String name;
  String type;
  String host;
  List<String> types = ['Workshop', 'Training', 'Seminar', 'Faculty'];

  validateAndSave() {
    final form = formKey.currentState;

    if (form.validate() && type != null) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmit() async {
    if (validateAndSave()) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CreateFeedback(host: host, name: name, type: type),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    name = '';
    host = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Host new feedback')),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: creationForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> creationForm() {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Name of the feedback'),
        validator: (value) => value.isEmpty ? "This field is required" : null,
        onSaved: (value) => name = value,
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Host name'),
        validator: (value) => value.isEmpty ? "This field is required" : null,
        onSaved: (value) => host = value,
      ),
      SizedBox(height: 25),
      Text(
        'What is the feedback for?',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      SizedBox(height: 15),
      RadioButtonGroup(
        labels: ["Workshop", "Training", "Seminar", "Faculty"],
        onSelected: (value) {
          type = value;
        },
      ),
      SizedBox(height: 15),
      RaisedButton(
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: validateAndSubmit,
      )
    ];
  }
}
