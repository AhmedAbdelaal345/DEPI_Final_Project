// lib/features/review_answers/domain/entities/review_question.dart

class ReviewQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String correctAnswer;
  final int userAnswerIndex;
  final String studentAnswer;
  final String explanation;
  final bool isCorrect;

  ReviewQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.correctAnswer,
    required this.userAnswerIndex,
    required this.studentAnswer,
    required this.explanation,
    required this.isCorrect,
  });
}