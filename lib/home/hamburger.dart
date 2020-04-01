import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HamBurger {
  Auth auth;
  SharedPreferences _prefs;

  List<Widget> menu(BuildContext context) {
    auth = new Auth(context);
    return <Widget>[
      ListTile(
        title: Text('Create feedback'),
        onTap: () async {
          _prefs = await SharedPreferences.getInstance();
          bool isAdmin = _prefs.getBool("admin");
          if (isAdmin) {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/nameFeedback');
          } else {
            Fluttertoast.showToast(
                msg: "Permission denied!",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIos: 1,
                textColor: Colors.white,
                backgroundColor: Colors.black,
                gravity: ToastGravity.BOTTOM);
          }
        },
      ),
      ListTile(
        title: Text('Open feedbacks'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/closedFeedback');
        },
      ),
      ListTile(
          title: Text('Logout'),
          onTap: () {
//            _prefs.remove("email");
//            _prefs.remove("admin");
            auth.signOut();
          })
    ];
  }
}
