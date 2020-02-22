import 'package:feedback_system/services/authManagement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';

class HamBurger {
  Auth auth;

  List<Widget> menu(BuildContext context, String _email) {
    auth = new Auth(context);
    return <Widget>[
      ListTile(
        title: Text('Create feedback'),
        onTap: () async {
          if(_email == null) {
            print("Email is null, so changing it");
            _email = await auth.getUserEmail();
          }
          auth.getAdmins(_email).then((doc) {
            if(doc.documents.length > 0 && _email!=null) {
              Navigator.of(context).pushReplacementNamed('/nameFeedback');
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
        }
      )
    ];
  }
}
