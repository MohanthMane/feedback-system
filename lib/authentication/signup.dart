import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = new GlobalKey<FormState>();
  String email = '', name = '', password = '';
  bool isHidden = true;
  Auth auth;

  validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmit() {
    if(validateAndSave()) {
      auth.signUp(email, password);
    }
  }


  @override
  void initState() {
    super.initState();
    auth = Auth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: registerForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> registerForm() {
    double width = MediaQuery.of(context).size.width;
    return <Widget>[
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? "Email is required" : null;
        },
        onSaved: (value) => email = value,
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
        onSaved: (value) => password = value,
      ),
      SizedBox(height: 15),
      SizedBox(
        width: width,
        child: RaisedButton(
          child: Text('Sign up'),
          onPressed: validateAndSubmit,
        ),
      )
    ];
  }
}