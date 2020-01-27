import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = new GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  Auth auth;

  @override
  void initState() {
    super.initState();
    auth = new Auth(context);
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
      auth.signIn(_email,_password);
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

  // Entire Form in returned by this function
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