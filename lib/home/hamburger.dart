import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';

class HamBurger {
  Auth auth;
  String _email;

  List<Widget> menu(BuildContext context) {
    auth = new Auth(context);
    return <Widget>[
      ListTile(
        title: Text('Create feedback'),
        onTap: () async {
          _email = await auth.getUserEmail();
          auth.getAdmins(_email).then((doc) {
            if (doc.documents.length > 0 && _email != null) {
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
          });
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
            auth.signOut();
          })
    ];
  }
}
