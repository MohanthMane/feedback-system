import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/QRCode/scanner.dart';
import 'package:feedback_system/services/authManagement.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hamburger.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:feedback_system/Feedback modification/edit_feedback.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HamBurger hamBurger = new HamBurger();
  int section;
  Auth auth;
  bool isAdmin;
  String email;
  String qrText;
  bool _statusStorage;
  Stream<QuerySnapshot> feedbacks;
  SharedPreferences _prefs;

  requestStoragePermissions() {
    if (Platform.isAndroid) {
      Permission.storage.isGranted.then((status) {
        setState(() {
          _statusStorage = status;
        });
      });
      Permission.storage.isPermanentlyDenied.then((status) {
        Fluttertoast.showToast(
            msg: 'Please grant storage permissions in the setting');
      });
      Permission.storage.isUndetermined.then((status) {
        Permission.storage.request();
      });
    } else if (Platform.isIOS) {
      Permission.photos.isGranted.then((status) {
        setState(() {
          _statusStorage = status;
        });
      });
      Permission.photos.isUndetermined.then((status) {
        Permission.storage.request();
      });
    }
  }

  instantiate() async {
    await SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isAdmin = prefs.getBool('admin');
        email = prefs.getString('email');
      });
    });
    print("_prefs set");
  }

  @override
  void initState() {
    super.initState();
    auth = new Auth(context);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isAdmin = prefs.getBool('admin');
        email = prefs.getString('email');
      });
      print("_prefs set");
    });
    // requestStoragePermissions();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(children: hamBurger.menu(context)),
      ),
      body: (isAdmin == null)
          ? loading()
          : (isAdmin) ? adminContent() : userContent(),
      floatingActionButton: FloatingActionButton(
          heroTag: 'Scan',
          child: Icon(Icons.camera),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Scanner()));
          },
          tooltip: 'QR Scanner'),
    );
  }

  loading() {
    return Center(
        child: SpinKitWave(
      color: Colors.blue,
    ));
  }

  adminContent() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('/feedbacks')
          .where('host_id', isEqualTo: email)
          .where('status', isEqualTo: "open")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditFeedback(feedback: feedback)));
                },
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Center(child: Text('No active feedbacks'));
        } else {
          return loading();
        }
      },
    );
  }

  userContent() {
    return Center(
      child: Text('Welcome ${_prefs.getString('email')}'),
    );
  }
}
