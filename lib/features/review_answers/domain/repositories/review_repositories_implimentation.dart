// lib/features/review_answers/data/repositories/review_repository_impl.dart
import '../../domain/entities/review_question.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  // Store the quiz results data
  List<ReviewQuestion>? _correctAnswers;
  List<ReviewQuestion>? _wrongAnswers;
  
  // Method to set quiz results data
  void setQuizResults(List<ReviewQuestion> correctAnswers, List<ReviewQuestion> wrongAnswers) {
    _correctAnswers = correctAnswers;
    _wrongAnswers = wrongAnswers;
  }

  @override
  Future<List<ReviewQuestion>> getCorrectAnswers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_correctAnswers == null) {
      throw Exception('No correct answers data available');
    }
    
    return _correctAnswers!;
  }

  @override
  Future<List<ReviewQuestion>> getWrongAnswers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_wrongAnswers == null) {
      throw Exception('No wrong answers data available');
    }
    
    return _wrongAnswers!;
  }
}