import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = new GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  Auth auth;
  bool isHidden = true;

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
    double width = MediaQuery.of(context).size.width - 50;
    return <Widget>[
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          suffixIcon: Icon(MdiIcons.email)
        ),
        validator: (value) {
          return value.isEmpty ? "Email is required" : null;
        },
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
                          icon: Icon(
                isHidden ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
            )
        ),
        obscureText: isHidden,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: width/2,
                      child: RaisedButton(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: validateAndSubmit,
            ),
          ),
          SizedBox(
            width: width/2,
                      child: RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          ),
        ],
      )
    ];
  }
}