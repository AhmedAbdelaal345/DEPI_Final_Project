import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';

class QuizHistoryModel {
  final String quizId;
  final double score;
  final int total;
  final String status;
  final DateTime? createdAt;
  final List<Map<String, dynamic>> details;

  QuizHistoryModel({
    required this.quizId,
    required this.score,
    required this.total,
    required this.status,
    this.createdAt,
    required this.details,
  });

  factory QuizHistoryModel.fromFirestore(
    String quizId,
    Map<String, dynamic> data,
    
  ) {
    return QuizHistoryModel(
      quizId: quizId,
      score: data[AppConstants.score] ?? 0,
      total: data[AppConstants.total] ?? 0,
      status: data[AppConstants.status] ?? 'Unknown',
      createdAt: (data[AppConstants.createdAt] as Timestamp?)?.toDate(),
      details: List<Map<String, dynamic>>.from(data[AppConstants.details] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AppConstants.score: score,
      AppConstants.total: total,
      AppConstants.status: status,
      AppConstants.createdAt: createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      AppConstants.details: details,
    };
  }

  double get accuracy => total > 0 ? score.toDouble() : 0.0;
  
  String get accuracyPercentage => '${(accuracy * 100).toStringAsFixed(0)}%';
  
  String get formattedDate {
    if (createdAt == null) return 'Unknown';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }
}

class SubjectQuizHistory {
  final String subjectName;
  final List<QuizHistoryModel> quizzes;

  SubjectQuizHistory({
    required this.subjectName,
    required this.quizzes,
  });

  double get averageScore {
    if (quizzes.isEmpty) return 0.0;
    double sum = quizzes.map((q) => q.accuracy).reduce((a, b) => a + b);
    return sum / quizzes.length;
  }

  String get averagePercentage => '${(averageScore * 100).toStringAsFixed(0)}%';
}