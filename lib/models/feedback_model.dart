class FeedbackModel {
  List<String> questions;
  List<int> scores;
  List<String> remarks;
  List<String> attended;
  List<bool> sections;
  String name, host;
  String status;

  FeedbackModel(questions,sections,name,host) {
    this.questions = questions;
    scores = new List<int>.filled(questions.length, 0, growable: false);
    remarks = new List<String>();
    attended = new List<String>();
    status = "open";
    this.sections = sections;
    this.name = name;
    this.host = host;
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