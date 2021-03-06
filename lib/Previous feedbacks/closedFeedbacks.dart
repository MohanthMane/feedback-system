import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/services/authManagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class ClosedFeedbacks extends StatefulWidget {
  @override
  _ClosedFeedbacksState createState() => _ClosedFeedbacksState();
}

class _ClosedFeedbacksState extends State<ClosedFeedbacks> {
  int section;
  Auth auth;
  bool isAdmin;
  String email;
  Stream<QuerySnapshot> feedbacks;
  SharedPreferences _prefs;

  instantiate() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool("admin")) {
      setState(() {
        isAdmin = true;
      });
    } else {
      setState(() {
        isAdmin = false;
      });
    }
    email = _prefs.getString("email");
  }

  @override
  void initState() {
    super.initState();
    auth = new Auth(context);
    instantiate();
  }

  Future<bool> getUserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      email = _prefs.getString('email');
      isAdmin = _prefs.getBool('admin');
    });

    return isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Closed feedbacks'),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return closedList();
          } else {
            return loading();
          }
        },
      ),
    );
  }

  loading() {
    return Center(child: SpinKitWave(color: Colors.blue,));
  }

  closedList() {
    return StreamBuilder(
      stream: Firestore.instance.collection('/feedbacks').where('host_id',isEqualTo: email).where('status',isEqualTo: "close").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data.documents.length == 0) return userContent();
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(height: 1.0, color: Colors.grey),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot feedback = snapshot.data.documents[index];

              return ListTile(
                title: Text(feedback.data['name']),
                subtitle: Text('Host : ' + feedback.data['host']),
                trailing: Text(feedback.data['type'] ?? ""),
                onTap: () {
                  // TODO: Go to statistics
                },
              );
            },
          );
        } else if(snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
          return userContent();
        } else {
          return loading();
        }
      },
    );
  }

  userContent() {
    return Center(
      child: Text('No feedbacks hosted'),
    );
  }
}
