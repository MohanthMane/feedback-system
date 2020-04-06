class FeedbackModel {
  List<String> questions;
  List<int> scores;
  List<String> remarks;
  List<String> attended;
  String type;
  String name, host;
  String status;
  String hostId;

  FeedbackModel(questions,type,name,host,hostId) {
    this.questions = questions;
    scores = new List<int>.filled(questions.length, 0, growable: false);
    remarks = new List<String>();
    attended = new List<String>();
    status = "open";
    this.type = type;
    this.name = name;
    this.host = host;
    this.hostId = hostId;
  }

  bool addQuestion(String question) {
    if(question.length > 0) {
      questions.add(question);
      print(questions);
      return true;
    }
    return false;
  }

  removeQuestion(int index) {
    questions.removeAt(index);
  }
}