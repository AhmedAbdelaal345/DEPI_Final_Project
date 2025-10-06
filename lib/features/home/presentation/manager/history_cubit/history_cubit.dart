import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/presentation/model/history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(InitialState());

  Future<void> getQuizzesForStudent(String uidForStudent) async {
    emit(LoadingState());
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get all quizzes from the subcollection
      QuerySnapshot<Map<String, dynamic>> quizzesSnapshot =
          await firestore
              .collection(AppConstants.studentCollection)
              .doc(uidForStudent)
              .collection(AppConstants.questionsCollection)
              .get();

      if (quizzesSnapshot.docs.isEmpty) {
        emit(EmptyState());
        return;
      }

      // Convert documents to QuizHistoryModel list
      List<QuizHistoryModel> allQuizzes =
          quizzesSnapshot.docs.map((doc) {
            return QuizHistoryModel.fromFirestore(doc.id, doc.data());
          }).toList();

      // Group quizzes by subject (extracted from quizId)
      Map<String, List<QuizHistoryModel>> groupedQuizzes = {};

      for (var quiz in allQuizzes) {
        // Extract subject from quizId (assuming format like "Math_quiz1", "Physics_basics", etc.)
        String subject = _extractSubjectFromQuizId(quiz.quizId);

        if (!groupedQuizzes.containsKey(subject)) {
          groupedQuizzes[subject] = [];
        }
        groupedQuizzes[subject]!.add(quiz);
      }

      emit(LoadedState(groupedQuizzes));
    } on FirebaseException catch (e) {
      emit(ErrorState(e.message ?? 'Failed to load quiz history'));
    } catch (e) {
      emit(ErrorState('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Helper method to extract subject name from quizId
  String _extractSubjectFromQuizId(String quizId) {
    // If quizId contains underscore, split and take first part
    if (quizId.contains('_')) {
      return quizId.split('_')[0];
    }

    // If quizId contains numbers, remove them and capitalize
    String subject = quizId.replaceAll(RegExp(r'[0-9]'), '').trim();

    // Capitalize first letter
    if (subject.isEmpty) return 'General';
    return subject[0].toUpperCase() + subject.substring(1);
  }

  // Optional: Method to get quizzes for a specific subject
  // Future<void> getQuizzesForSubject(String uidForStudent, String subject) async {
  //   emit(LoadingState());
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     QuerySnapshot<Map<String, dynamic>> quizzesSnapshot = await firestore
  //         .collection(AppConstants.studentCollection)
  //         .doc(uidForStudent)
  //         .collection(AppConstants.questionsCollection)
  //         .get();

  //     if (quizzesSnapshot.docs.isEmpty) {
  //       emit(EmptyState());
  //       return;
  //     }

  //     List<QuizHistoryModel> filteredQuizzes = quizzesSnapshot.docs
  //         .map((doc) => QuizHistoryModel.fromFirestore(doc.id, doc.data()))
  //         .where((quiz) => _extractSubjectFromQuizId(quiz.quizId) == subject)
  //         .toList();

  //     Map<String, List<QuizHistoryModel>> groupedQuizzes = {
  //       subject: filteredQuizzes
  //     };

  //     emit(LoadedState(groupedQuizzes));
  //   } on FirebaseException catch (e) {
  //     emit(ErrorState(e.message ?? 'Failed to load quiz history'));
  //   } catch (e) {
  //     emit(ErrorState('An unexpected error occurred: ${e.toString()}'));
  //   }
  // }
  // void resetState() {
  //   emit(InitialState());
  // }
}
