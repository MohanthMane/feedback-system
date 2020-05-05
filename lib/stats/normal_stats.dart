import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NormalStats extends StatefulWidget {
  final String docId;

  NormalStats(this.docId);

  @override
  _NormalStatsState createState() => _NormalStatsState();
}

class _NormalStatsState extends State<NormalStats> {
  var _data;

  Future<bool> setData() async {
    var data = await Firestore.instance
        .collection('/feedbacks')
        .document(widget.docId)
        .get();
    setState(() {
      _data = data;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: FutureBuilder(
        future: setData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text('People attended : ' + (_data['attended'].length).toString()),
            );
          } else {
            return loading();
          }
        },
      ),
    );
  }

  loading() {
    return Center(
      child: SpinKitWave(
        color: Colors.blue,
      ),
    );
  }
}
