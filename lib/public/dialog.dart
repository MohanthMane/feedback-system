import 'package:flutter/material.dart';

class DialogPopUp {

  String title,content;
  BuildContext context;

  DialogPopUp({this.content,this.title,this.context});

  dialogPopup() {
      showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(this.title),
            content: Text(this.content),
            actions: <Widget>[
              FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        },
      );
    }
}