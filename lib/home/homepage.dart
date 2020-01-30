import 'package:feedback_system/services/authManagement.dart';
import 'hamburger.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _email;
  HamBurger hamBurger = new HamBurger();
  Auth auth;

  setEmail() async {
    print("setting email");
    _email = await auth.getUserEmail();
    print("Email set $_email");
  }

  @override
  void initState() {
    super.initState();
    auth = new Auth(context);
    setEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('LOGOUT'),
            onPressed: () => auth.signOut(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(children: hamBurger.menu(context,_email)),
      ),
      body: Center(child: Text('Welcome')),
    );
  }
}
