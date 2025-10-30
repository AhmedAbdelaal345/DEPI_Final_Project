// lib/features/review_answers/presentation/cubit/review_answers_cubit.dart
// import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/review_question.dart';
import 'review_answers_state.dart';

class ReviewAnswersCubit extends Cubit<ReviewAnswersState> {
  ReviewAnswersCubit() : super(ReviewAnswersInitial());

  // Store quiz results internally
  List<ReviewQuestion> _correctAnswers = [];
  List<ReviewQuestion> _wrongAnswers = [];

  // Method to set quiz results
  void setQuizResults(
      List<ReviewQuestion> correctAnswers,
      List<ReviewQuestion> wrongAnswers,
      ) {
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

      final resultDoc =
      await FirebaseFirestore.instance
          .collection(AppConstants.studentCollection)
          .doc(studentId)
          .collection(AppConstants.quizzessmall)
          .doc(quizId)
          .get();

      // 🔹 Check if no results found
      if (!resultDoc.exists) {
        emit(
          const ReviewAnswersError('No quiz results found for this student.'),
        );
        return;
      }

      // ✅ Safe access
      final resultData = resultDoc.data()!;
      // for debuge test
      // print("Result Data: ${resultData.toString()}");

      // Parse answers
      final answersData = resultData[AppConstants.details] ?? [];
      if (answersData.isEmpty) {
        emit(const ReviewAnswersError('No answers found in Firestore.'));
        return;
      }

      for (var answerData in answersData) {
        final question = ReviewQuestion(
          teacherId: answerData['teacherId'] ?? '',
          id: answerData['id'] ?? '',
          questionText: answerData['question'] ?? '',
          options: List<String>.from(answerData['options'] ?? []),
          correctAnswerIndex: answerData['correctAnswerIndex'] ?? 0,
          correctAnswer: answerData['correctAnswer'] ?? '',
          userAnswerIndex: answerData['userAnswerIndex'] ?? -1,
          studentAnswer: answerData['studentAnswer'] ?? '',
          explanation: answerData['explanation'] ?? '',
          isCorrect:  (answerData['studentAnswer']?.toString().trim() ==
            answerData['answer']?.toString().trim()),
        );

        if (question.isCorrect) {
          _correctAnswers.add(question);
        } else {
          _wrongAnswers.add(question);
        }
      }

      // ✅ Return to initial state after loading
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