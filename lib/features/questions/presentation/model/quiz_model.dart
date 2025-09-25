import 'package:depi_final_project/core/constants/app_constants.dart';

class QuestionModel {
  final String text;
  final Map<String, String> options;
  final String correctAnswer;
  final int points;

  QuestionModel({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.points,
  });

  factory QuestionModel.fromFirestore(Map<String, dynamic> data) {
    return QuestionModel(
      text: data[AppConstants.text] ?? '',
      options: Map<String, String>.from(data[AppConstants.options] ?? {}),
      correctAnswer: data[AppConstants.correctAnswer] ?? '',
      points: data[AppConstants.points] ?? 0,
    );
  }
}
