import 'package:flutter/material.dart';

//import 'package:charts_flutter/flutter.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Pie Chart Total Stats

            //https://medium.com/flutter/beautiful-animated-charts-for-flutter-164940780b8c
            //https://google.github.io/charts/flutter/gallery.html

            //Question Wise Stats
          ],
        ),
      ),
    );
  }
}
