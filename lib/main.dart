import 'package:feedback_system/Feedback%20creation/GenerateScreen.dart';
import 'package:feedback_system/Feedback%20creation/namingFeedback.dart';
import 'package:feedback_system/screens/closedFeedbacks.dart';
import 'package:flutter/services.dart';
import 'Feedback creation/createFeedback.dart';
import 'home/homepage.dart';
import 'authentication/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes: <String, WidgetBuilder> {
        '/nameFeedback': (BuildContext context) => new NamingFeedback(),
        '/landingpage': (BuildContext context) => new MyApp(),
        '/homepage': (BuildContext context) => new HomePage(),
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
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          return HomePage();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else
          return null;
      },
    );
  }
}
