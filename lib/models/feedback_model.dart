import 'package:feedback_system/Feedback creation/createFeedback.dart';

enum MetricType { Satisfaction, GoalCompletionRate, EffortScore, SmileyRating }

class FeedbackModel {
  List<Question> questionObjects;
  List<String> questions, metrics;
  Map<String,List<int>> scores;
  List<String> remarks;
  List<double> averageScores;
  List<String> attended;
  String type;
  String name, host;
  String status;
  String hostId;

  FeedbackModel(questions, type, name, host, hostId) {
    this.questionObjects = questions;
    this.remarks = new List<String>();
    this.averageScores = new List<double>();
    this.attended = new List<String>();
    this.questions = new List<String>();
    this.metrics = new List<String>();
    this.status = "open";
    this.type = type;
    this.name = name;
    this.host = host;
    this.hostId = hostId;

    this.questionObjects.forEach((o) {
      decodeObject(o);
    });
    this.scores = initializeScores(metrics);
  }

  initializeScores(metrics) {
    Map<String,List<int>> scores = new Map<String,List<int>>();
    int idx = 0;
    metrics.forEach((metric) {
      int length;
      if (metric == 'EffortScore')
        length = 5;
      else if (metric == 'SmileyRating')
        length = 5;
      else if (metric == 'GoalCompletionRate')
        length = 3;
      else
        length = 5;
      List<int> tempList = new List<int>.filled(length, 0,growable: false);
      scores[idx.toString()] = (tempList);
      idx++;
    });
    return scores;
  }

  decodeObject(Question object) {
    this.questions.add(object.questionData);
    this.metrics.add(enumToString(object.metricType));
  }

  String enumToString(o) {
    return o.toString().split('.').last;
  }

  MetricType enumFromString(String val, List<MetricType> values) =>
      values.firstWhere((v) => val == enumToString(v), orElse: () => null);

  removeQuestion(int index) {
    questions.removeAt(index);
  }
}
