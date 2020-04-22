import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/stats/statistics_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//import 'package:charts_flutter/flutter.dart';

class Statistics extends StatefulWidget {
  String docId;

  Statistics(this.docId);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Stats stats;
  List<double> averages;
  List<int> bands;
  double overAllAverage;
  var scores;
  var _data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: FutureBuilder(
        future: setData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('List of avgs: ' + stats.getAverageScores().toString()),
                  Text('Avgs distribution: ' +
                      stats.getScoresSpectrum().toString()),
                  Text('Overall Avg: ' + stats.getOverallAverage().toString()),
                  Text('Scores for each question: ' +
                      stats.getScores().toString())
                ],
              ),
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
    ));
  }

  Future<bool> setData() async {
    var data = await Firestore.instance
        .collection('/feedbacks')
        .document(widget.docId)
        .get();
    setState(() {
      _data = data;
    });
    stats = new Stats(widget.docId, _data);
    return true;
  }
}
