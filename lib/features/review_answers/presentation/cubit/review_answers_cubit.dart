// lib/features/review_answers/presentation/cubit/review_answers_cubit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/review_question.dart';
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

  // ADD THIS METHOD - Fetch all answers (correct + wrong)
  Future<void> fetchAllAnswers() async {
    try {
      emit(ReviewAnswersLoading());
      
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      var allAnswers = [..._correctAnswers, ..._wrongAnswers];
      
      if (allAnswers.isEmpty) {
        emit(ReviewAnswersError('No answers found.'));
        return;
      }
      
      emit(ReviewAnswersLoaded(allAnswers));
    } catch (e) {
      emit(ReviewAnswersError('Failed to fetch all answers.'));
    }
  }

  Future<void> loadStudentAnswers({
    required String quizId,
    required String studentId,
  }) async {
    try {
      emit(ReviewAnswersLoading());

      // Fetch the student's quiz result from Firebase
      var resultDoc = await FirebaseFirestore.instance
          .collection('quiz_results') // Change to your collection name
          .where('quizId', isEqualTo: quizId)
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get();

      if (resultDoc.docs.isEmpty) {
        emit(ReviewAnswersError('No results found for this quiz.'));
        return;
      }

      var resultData = resultDoc.docs.first.data();
      
      // Parse the answers from Firebase
      List<dynamic> answersData = resultData['answers'] ?? [];
      
      _correctAnswers = [];
      _wrongAnswers = [];

      for (var answerData in answersData) {
        var question = ReviewQuestion(
          id: answerData['id'] ?? '',
          questionText: answerData['question'] ?? '',
          options: List<String>.from(answerData['options'] ?? []),
          correctAnswerIndex: answerData['correctAnswerIndex'] ?? 0,
          correctAnswer: answerData['correctAnswer'] ?? '',
          userAnswerIndex: answerData['userAnswerIndex'] ?? -1,
          studentAnswer: answerData['studentAnswer'] ?? '',
          explanation: answerData['explanation'] ?? '',
          isCorrect: answerData['isCorrect'] ?? false,
        );

        if (question.isCorrect) {
          _correctAnswers.add(question);
        } else {
          _wrongAnswers.add(question);
        }
      }

      emit(ReviewAnswersInitial());
    } catch (e) {
      emit(ReviewAnswersError('Failed to load answers: ${e.toString()}'));
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