import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = new GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  _checkDatabase() async {
    CollectionReference dbRef = Firestore.instance.collection('allusers');

    dbRef.document(_email).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        // User can login
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((user) {
          Navigator.of(context).pushReplacementNamed('/homepage');
        }).catchError((e) {
          print(e);
        });
      } else {
        dialogPopup(title: "Login error", content: "User doesn't exist");
      }
    }).catchError((e) {
      print(e);
    });
    return false;
  }

  dialogPopup({title, content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  validateAndSave() {
    final form = formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmit() async {
    if (validateAndSave()) {
      _checkDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: loginForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> loginForm() {
    return <Widget>[
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? "Email is required" : null;
        },
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value.isEmpty)
            return "Password is required";
          else if (value.length < 6)
            return "Password must contain atleast 6 characters";
          else
            return null;
        },
        onSaved: (value) => _password = value,
      ),
      SizedBox(height: 15),
      RaisedButton(
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: validateAndSubmit,
      )
    ];
  }
}