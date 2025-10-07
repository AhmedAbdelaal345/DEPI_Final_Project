import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/result_state.dart';
import 'package:depi_final_project/features/questions/presentation/model/question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultCubit extends Cubit<ResultState> {
  ResultCubit() : super(InitState());
  Future<void> saveStudentQuizResult({
    required String studentId,
    required String quizId,
    required List<Map<String, dynamic>> questionsWithAnswers,
    required List<QuestionModel> questions,
    required String status,
  }) async {
    emit(LoadingState());
    try {
      final firestore = FirebaseFirestore.instance;

      int correctCount =
          questionsWithAnswers
              .where((q) => q['studentAnswer'] == q['answer'])
              .length;
      List<Map<String, dynamic>> questionsForFirestore =
          questions.map((q) => q.toFirestore()).toList();
      await firestore
          .collection(AppConstants.studentCollection)
          .doc(studentId)
          .collection(AppConstants.questionsCollection)
          .doc(quizId)
          .set({
            AppConstants.score: correctCount,
            AppConstants.total: questionsWithAnswers.length,
            AppConstants.details: questionsWithAnswers,
            AppConstants.status:status,
            AppConstants.question: questionsForFirestore,
            AppConstants.createdAt: FieldValue.serverTimestamp(),
          });
      emit(LoadedState());
    } on FirebaseException catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
