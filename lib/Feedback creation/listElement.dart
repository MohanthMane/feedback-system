import 'package:flutter/material.dart';

class ListElement extends StatelessWidget {
  final int index;
  final String question;

  ListElement({this.index, this.question});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        (index + 1).toString() + ")",
        style: TextStyle(fontSize: 20),
      ),
      title: Text(question),
      onTap: () {

      },
      onLongPress: () {
        
      },
    );
  }
}
