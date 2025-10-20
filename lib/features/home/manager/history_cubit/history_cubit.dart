import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/home/model/history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(InitialState());

  List<QuizHistoryModel> allQuizzes = [];
  Map<String, List<QuizHistoryModel>> groupedQuizzes = {};

  Future<void> getQuizzesForStudent(String uidForStudent) async {
    emit(LoadingState());
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 🔹 نجيب كل الكويزات من Firestore
      QuerySnapshot<Map<String, dynamic>> quizzesSnapshot =
          await firestore
              .collection(AppConstants.studentCollection)
              .doc(uidForStudent)
              .collection(AppConstants.quizzessmall)
              .get();

      // 🔹 العدد الفعلي من Firestore
      int totalQuizzes = quizzesSnapshot.docs.length;
      print("✅ Total actual quizzes taken: $totalQuizzes");

      if (quizzesSnapshot.docs.isEmpty) {
        emit(EmptyState());
        return;
      }

      // ✅ امسح اللي قبل كده عشان ميتراكمش
      allQuizzes.clear();

      groupedQuizzes.clear();
      // 🔹 حوّل كل كويز إلى موديل
      for (var doc in quizzesSnapshot.docs) {
        try {
          final quizData = doc.data();
          allQuizzes.add(QuizHistoryModel.fromFirestore(doc.id, quizData));
        } catch (e) {
          print('Error processing quiz ${doc.id}: $e');
        }
      }

      if (allQuizzes.isEmpty) {
        emit(EmptyState());
        return;
      }

      // 🔹 نجمعهم حسب المادة
      for (var quiz in allQuizzes) {
        String subject = await _getSubjectFromQuizId(quiz.quizId);
        groupedQuizzes.putIfAbsent(subject, () => []).add(quiz);
      }

      // 🔹 نمرر العدد الحقيقي كمان
      emit(LoadedState(groupedQuizzes, totalQuizzes));
    } on FirebaseException catch (e) {
      emit(ErrorState(e.message ?? 'Failed to load quiz history'));
    } catch (e) {
      emit(ErrorState('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // 🔹 Helper: نجيب المادة من كويز
  Future<String> _getSubjectFromQuizId(String quizId) async {
    try {
      final quizDoc =
          await FirebaseFirestore.instance
              .collection(AppConstants.quizzesCollection)
              .doc(quizId)
              .get();

      if (quizDoc.exists) {
        final data = quizDoc.data();
        if (data != null && data['subject'] != null) {
          String subject = data['subject'].toString();
          return subject.isEmpty
              ? 'General'
              : subject[0].toUpperCase() + subject.substring(1);
        }
      }
    } catch (e) {
      print('Error fetching subject for quiz $quizId: $e');
    }

    return _extractSubjectFromQuizId(quizId);
  }

  String _extractSubjectFromQuizId(String quizId) {
    if (quizId.contains('_')) {
      String subject = quizId.split('_')[0];
      return subject[0].toUpperCase() + subject.substring(1);
    }
    String subject = quizId.replaceAll(RegExp(r'[0-9]'), '').trim();
    if (subject.isEmpty) return 'General';
    return subject[0].toUpperCase() + subject.substring(1);
  }
}
