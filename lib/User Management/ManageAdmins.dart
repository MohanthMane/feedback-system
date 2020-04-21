import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAdmins extends StatefulWidget {
  @override
  _ManageAdminsState createState() => _ManageAdminsState();
}

class _ManageAdminsState extends State<ManageAdmins> {
  bool isRoot;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getUserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      isRoot = _prefs.getBool('root');
    });

    return isRoot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admins'),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listWidget();
          } else {
            return loading();
          }
        },
      ),
    );
  }

  listWidget() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('/users')
          .where('isadmin', isEqualTo: true)
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(height: 1.0, color: Colors.grey),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot userData = snapshot.data.documents[index];
              return ListTile(
                  title: Text(userData.data['name']),
                  subtitle: Text(userData.data['email']),
                  trailing: FlatButton(
                    child: Icon(
                      MdiIcons.minusCircleOutline,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await removeUser(userData);
                    },
                  ));
            },
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Center(child: Text('No Admins'));
        } else {
          return loading();
        }
      },
    );
  }

  removeUser(user) async {
    
  }

  loading() {
    return Center(
        child: SpinKitWave(
      color: Colors.blue,
    ));
  }
}
