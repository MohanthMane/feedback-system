import 'package:cloud_firestore/cloud_firestore.dart';
import '../public/spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../public/dialog.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = new GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool loading = false;

  validateAndSave() {
    final form = formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  login() {
    print('logging in');
    setState(() => loading=true);
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email,
      password: _password
    ).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
      setState(() => loading=false);
      DialogPopUp dialog = new DialogPopUp(
          title: 'Error',
          content: "Couldn't sign in with above credentials",
          context: context
        );
      dialog.dialogPopup();
    });
  }

  validateAndSubmit() async {
    if (validateAndSave()) {
      login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Spinner() : Scaffold(
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