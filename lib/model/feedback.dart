class Feedback {
  List<String> questions;
  List<int> scores;

  addQuestion(String question) {
    questions.add(question);
  }

  removeQuestion(int index) {
    questions.removeAt(index);
  }

  
  
}