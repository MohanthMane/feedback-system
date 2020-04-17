import 'package:feedback_system/Feedback%20creation/namingFeedback.dart';
import 'package:feedback_system/Previous%20feedbacks/closedFeedbacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Feedback creation/createFeedback.dart';
import 'authentication/loginpage.dart';
import 'home/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen.navigate(
        name: 'assets/SplashScreen.flr',
        next: (context) => LandingPage(),
        until: () => Future.delayed(Duration(seconds: 5)),
        //isLoading: false,
        startAnimation: 'Login Page',
        fit: BoxFit.cover,
        backgroundColor: Colors.white,
      ),
      routes: <String, WidgetBuilder>{
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
