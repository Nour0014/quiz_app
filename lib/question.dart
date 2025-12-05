class Question {
  final int id;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;

  Question({
    required this.id,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      answer: map['answer'],
    );
  }

  List<String> get options => [option1, option2, option3, option4];
}