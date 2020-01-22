import 'package:feedback_system/screens/closedFeedbacks.dart';
import 'package:feedback_system/screens/createFeedback.dart';
import 'package:feedback_system/screens/homepage.dart';
import 'package:feedback_system/screens/loginpage.dart';
import 'package:feedback_system/screens/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes: <String,WidgetBuilder> {
        '/landingpage': (BuildContext context) => new MyApp(),
        // '/signup': (BuildContext context) => new SignupPage(),
        '/homepage': (BuildContext context) => new HomePage(),
        '/test': (BuildContext context) => new Testing(),
        '/createFeedback': (BuildContext context) => new CreateFeedback(),
        '/closedFeedback': (BuildContext context) => new ClosedFeedbacks()
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if(user == null) {
            return LoginPage();
          }
          return HomePage();
        }
        else if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else return null;
      },
    );
  }
}