import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/model/quiz_model.dart' show QuestionModel;
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(InitState());

  Future<List<QuestionModel>> getQuestions(String quizId) async {
    emit(LoadingState());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection) 
          .doc(quizId)                                
          .collection(AppConstants.questionsCollection) 
          .get();

      final questions = snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc.data()))
          .toList();

      emit(LoadedState(questions));
      return questions;
    } on FirebaseException catch (e) {
      emit(ErrorState(e.message ?? 'An error occurred while fetching questions.'));
      return [];
    } catch (e) {
      emit(ErrorState('An unexpected error occurred.'));
      return [];
    }
  }
}
