import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Answer extends StatefulWidget {
  final String data;

  Answer({this.data});

  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  var data;
  bool attended;
  bool perform = false;
  String email;
  List<double> scores;
  List<dynamic> updated;

  instantiate() async {
    Firestore.instance
        .collection('/feedbacks')
        .document(widget.data)
        .get()
        .then((_data) {
      setState(() {
        data = _data;
        scores = new List<double>.filled(data['questions'].length, 1,
            growable: false);
      });
    });
  }

  getSharedPreferences() async {
    SharedPreferences.getInstance().then((val) {
      setState(() {
        email = val.getString("email");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    instantiate();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return data == null
        ? SpinKitThreeBounce(color: Colors.blue)
        : data['attended'].contains(email) ? stopUser() : fetchDocument(width);
  }

  stopUser() {
    return Scaffold(
        body: Center(
      child: Text('Can\'t give feedback more than once'),
    ));
  }

  fetchDocument(double width) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          height: 1,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    (index + 1).toString() + ")",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    data['questions'][index],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SliderTheme(
                  data: themeData(),
                  child: Slider(
                    value: scores[index],
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: scores[index].toString(),
                    onChanged: (_value) {
                      setState(
                        () {
                          scores[index] = _value;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: data['questions'].length,
      ),
      persistentFooterButtons: <Widget>[
        SizedBox(
          width: width,
          child: RaisedButton(
            color: Colors.blue,
            child: Text('Submit'),
            onPressed: () async {
              uploadFeedback(context);
            },
          ),
        )
      ],
    );
  }

  updateScores() async {
    await Firestore.instance
        .collection('/feedbacks')
        .document(widget.data)
        .get()
        .then((doc) {
      print(doc['scores']);
      var prev = List();
      for (int x = 0;x < doc['scores'].length;x++) prev.add(doc['scores'][x]);
      int idx = 0;
      while (idx < scores.length) {
        prev[idx] += scores[idx];
        idx++;
      }
      setState(() {
        updated = prev;
      });
      print(updated);
    });
  }

  uploadFeedback(context) {
    var ref = Firestore.instance.collection('/feedbacks').document(widget.data);
    Firestore.instance.runTransaction((tx) async {
      await updateScores();
      await tx.update(ref, {
        'scores': updated,
        'attended': FieldValue.arrayUnion([email])
      });
    }).then((val) {
      print("updated");
      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'Success',
          desc: 'Feedback submitted successfully',
          dismissOnTouchOutside: false,
          btnOkOnPress: () {
            Navigator.of(context, rootNavigator: false).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/homepage', (r) => false);
          }).show();
    });
  }

  themeData() {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.red[700],
      inactiveTrackColor: Colors.red[100],
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 3.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
      thumbColor: Colors.redAccent,
      overlayColor: Colors.red.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.red[700],
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.redAccent,
      valueIndicatorTextStyle: TextStyle(
        color: Colors.white,
      ),
    );
  }
}
