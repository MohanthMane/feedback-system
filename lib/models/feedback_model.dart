import 'package:feedback_system/Feedback creation/createFeedback.dart';

enum MetricType { Satisfaction, GoalCompletionRate, EffortScore, SmileyRating }

class FeedbackModel {
  List<Question> questionObjects;
  List<String> questions, metrics;
  List<int> scores;
  List<String> remarks;
  List<String> attended;
  String type;
  String name, host;
  String status;
  String hostId;

  FeedbackModel(questions, type, name, host, hostId) {
    this.questionObjects = questions;
    this.scores = new List<int>.filled(questions.length, 0, growable: false);
    this.remarks = new List<String>();
    this.attended = new List<String>();
    this.questions = new List<String>();
    this.metrics = new List<String>();
    this.status = "open";
    this.type = type;
    this.name = name;
    this.host = host;
    this.hostId = hostId;

    this.questionObjects.forEach((o){
      decodeObject(o);
    });
  }

  decodeObject(Question object) {
    print(object.questionData);
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
