import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _email;

  setEmail() async {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _email = user.email;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setEmail();
  }

  logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
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
            onPressed: logout,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(children: hamBurger()),
      ),
      body: Center(child: Text('Welcome')),
    );
  }

  List<Widget> hamBurger() {
    return <Widget>[
      ListTile(
        title: Text('Create feedback'),
        onTap: () {
          Firestore.instance
              .collection('/adminusers')
              .where('email', isEqualTo: _email)
              .getDocuments()
              .then((data) {
            if (data.documents.length > 0) {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/createFeedback');
            } else {
              Fluttertoast.showToast(
                  msg: "Permission denied!",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIos: 1,
                  textColor: Colors.white,
                  backgroundColor: Colors.black,
                  gravity: ToastGravity.BOTTOM);
            }
          });
        },
      ),
      ListTile(
        title: Text('Open feedbacks'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/closedFeedback');
        },
      )
    ];
  }
}
