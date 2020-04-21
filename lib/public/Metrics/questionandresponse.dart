class QuestionAndResponse {
  //int listIndex;
  String question;
  int response;
  String MetricType;

  QuestionAndResponse(this.question, this.MetricType) {
    switch (this.MetricType) {
      case 'Satisfaction':
        this.response = 5;
        break;
      case 'SmileyRating':
        this.response = 3;
        break;
      case 'EffortScore':
        this.response = 3;
        break;
      case 'GoalCompletionRate':
        this.response = 2;
        break;
    }
  }
}
