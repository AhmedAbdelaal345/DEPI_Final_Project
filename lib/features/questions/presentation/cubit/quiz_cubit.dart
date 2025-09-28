import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/model/quiz_model.dart' show QuestionModel;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(InitState());

  Future<void> getQuestions(String quizId) async {
    developer.log('QuizCubit: getQuestions called with ID: $quizId');
    emit(LoadingState());
    
    try {
      developer.log('QuizCubit: Starting Firestore query...');
      developer.log('QuizCubit: Collection path: ${AppConstants.quizzesCollection}/$quizId/${AppConstants.questionsCollection}');
      
      // First check if the quiz document exists
      final quizDoc = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .get();
          
      if (!quizDoc.exists) {
        developer.log('QuizCubit: Quiz document does not exist');
        emit(ErrorState('Quiz with ID "$quizId" not found'));
        return;
      }
      
      developer.log('QuizCubit: Quiz document exists, fetching questions...');
      
      // Then get the questions (remove orderBy since you don't have 'order' field)
      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .collection(AppConstants.questionsCollection)
          .get();
      
      developer.log('QuizCubit: Got ${snapshot.docs.length} question documents');
      
      if (snapshot.docs.isEmpty) {
        developer.log('QuizCubit: No questions found in quiz');
        emit(ErrorState('No questions found in this quiz'));
        return;
      }
      
      final List<QuestionModel> questions = [];
      
      for (var doc in snapshot.docs) {
        try {
          developer.log('QuizCubit: Processing document ${doc.id}');
          developer.log('QuizCubit: Document data: ${doc.data()}');
          
          final question = QuestionModel.fromFirestore(doc.data());
          questions.add(question);
          developer.log('QuizCubit: Successfully parsed question: ${question.text}');
        } catch (e) {
          developer.log('QuizCubit: Error parsing question ${doc.id}: $e');
          // Continue with other questions even if one fails
        }
      }
      
      if (questions.isEmpty) {
        developer.log('QuizCubit: No valid questions could be parsed');
        emit(ErrorState('Unable to load quiz questions. Please check the quiz format.'));
        return;
      }
      
      developer.log('QuizCubit: Successfully loaded ${questions.length} questions');
      emit(LoadedState(questions));
      
    } on FirebaseException catch (e) {
      developer.log('QuizCubit: Firebase error: ${e.code} - ${e.message}');
      String errorMessage;
      
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'Permission denied. Please check your access rights.';
          break;
        case 'not-found':
          errorMessage = 'Quiz not found. Please check the quiz ID.';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again.';
          break;
        default:
          errorMessage = e.message ?? 'Firebase error occurred';
      }
      
      emit(ErrorState(errorMessage));
      
    } catch (e) {
      developer.log('QuizCubit: Unexpected error: $e');
      emit(ErrorState('An unexpected error occurred: ${e.toString()}'));
    }
  }
  
  // Helper method to test Firestore connection
  Future<void> testFirestoreConnection() async {
    try {
      developer.log('QuizCubit: Testing Firestore connection...');
      
      final testSnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection)
          .limit(1)
          .get();
          
      developer.log('QuizCubit: Firestore connection test successful');
      developer.log('QuizCubit: Available quizzes count: ${testSnapshot.docs.length}');
      
      if (testSnapshot.docs.isNotEmpty) {
        developer.log('QuizCubit: Sample quiz ID: ${testSnapshot.docs.first.id}');
      }
      
    } catch (e) {
      developer.log('QuizCubit: Firestore connection test failed: $e');
    }
  }
  
  // Method to get all available quiz IDs (for debugging)
  Future<List<String>> getAvailableQuizIds() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.quizzesCollection)
          .get();
          
      final quizIds = snapshot.docs.map((doc) => doc.id).toList();
      developer.log('QuizCubit: Available quiz IDs: $quizIds');
      
      return quizIds;
    } catch (e) {
      developer.log('QuizCubit: Error getting available quiz IDs: $e');
      return [];
    }
  }
}