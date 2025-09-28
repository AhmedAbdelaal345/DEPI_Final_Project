// lib/features/review_answers/presentation/cubit/review_answers_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/review_question.dart';
import 'review_answers_state.dart';

class ReviewAnswersCubit extends Cubit<ReviewAnswersState> {
  ReviewAnswersCubit() : super(ReviewAnswersInitial());

  // Store quiz results internally
  List<ReviewQuestion> _correctAnswers = [];
  List<ReviewQuestion> _wrongAnswers = [];

  // Method to set quiz results
  void setQuizResults(List<ReviewQuestion> correctAnswers, List<ReviewQuestion> wrongAnswers) {
    _correctAnswers = correctAnswers;
    _wrongAnswers = wrongAnswers;
  }

  // وظيفة لجلب الإجابات الخاطئة
  Future<void> fetchWrongAnswers() async {
    try {
      emit(ReviewAnswersLoading());
      
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (_wrongAnswers.isEmpty) {
        emit(ReviewAnswersError('No wrong answers found.'));
        return;
      }
      
      emit(ReviewAnswersLoaded(_wrongAnswers));
    } catch (e) {
      emit(ReviewAnswersError('Failed to fetch wrong answers.'));
    }
  }

  // وظيفة لجلب الإجابات الصحيحة
  Future<void> fetchCorrectAnswers() async {
    try {
      emit(ReviewAnswersLoading());
      
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (_correctAnswers.isEmpty) {
        emit(ReviewAnswersError('No correct answers found.'));
        return;
      }
      
      emit(ReviewAnswersLoaded(_correctAnswers));
    } catch (e) {
      emit(ReviewAnswersError('Failed to fetch correct answers.'));
    }
  }

  // Helper method to get all answers
  List<ReviewQuestion> getAllAnswers() {
    return [..._correctAnswers, ..._wrongAnswers];
  }

  // Helper methods to get counts
  int get correctCount => _correctAnswers.length;
  int get wrongCount => _wrongAnswers.length;
  int get totalCount => correctCount + wrongCount;
}