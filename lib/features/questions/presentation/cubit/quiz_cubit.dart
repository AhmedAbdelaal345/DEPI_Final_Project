import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:depi_final_project/features/questions/presentation/model/question_model.dart'
    show QuestionModel;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(InitState());

  bool _disposed = false;

  @override
  Future<void> close() async {
    _disposed = true;
    await super.close();
  }

  // Custom dispose method that can be called manually
  void dispose() {
    if (!isClosed) {
      _disposed = true;
      close();
    }
  }

  Future<void> getQuestions(String quizId, String teacherId) async {
    // Check if cubit is already disposed or closed
    if (_disposed || isClosed) {
      return;
    }

    // Validate quizId
    if (quizId.isEmpty) {
      if (!_disposed && !isClosed) {
        emit(ErrorState('Invalid quiz ID'));
      }
      return;
    }

    if (state is! LoadingState) {
      emit(LoadingState());
    }

    try {
      final quizDoc = await FirebaseFirestore.instance
          .collection(AppConstants.teacherCollection)
          .doc(teacherId)
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .get()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Request timeout: Unable to connect to server');
            },
          );

      if (!quizDoc.exists) {
        if (!_disposed && !isClosed) {
          emit(ErrorState('Quiz with ID "$quizId" not found'));
        }
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.teacherCollection)
          .doc(teacherId)
          .collection(AppConstants.quizzesCollection)
          .doc(quizId)
          .collection(AppConstants.questionsCollection)
          .get()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Request timeout: Unable to load questions');
            },
          );

      if (snapshot.docs.isEmpty) {
        if (!_disposed && !isClosed) {
          emit(ErrorState('No questions found in this quiz'));
        }
        return;
      }

      final List<QuestionModel> questions = [];
      final List<String> parseErrors = [];

      for (var doc in snapshot.docs) {
        try {
          final docData = doc.data();

          // Check if document has required fields
          if (docData.isEmpty) {
            parseErrors.add('Document ${doc.id} is empty');
            continue;
          }

          final question = QuestionModel.fromFirestore(docData);
          questions.add(question);
        } catch (e, stackTrace) {
          parseErrors.add('Question ${doc.id}: ${e.toString()}');
          // Continue with other questions even if one fails
        }
      }

      if (questions.isEmpty) {
        final errorMsg =
            parseErrors.isNotEmpty
                ? 'Unable to load quiz questions:\n${parseErrors.join('\n')}'
                : 'Unable to load quiz questions. Please check the quiz format.';

        developer.log('QuizCubit: No valid questions could be parsed');
        if (!_disposed && !isClosed) {
          emit(ErrorState(errorMsg));
        }
        return;
      }

      // Log parsing errors but still proceed if we have some valid questions
      if (parseErrors.isNotEmpty) {
        developer.log(
          'QuizCubit: Some questions failed to parse: ${parseErrors.join(', ')}',
        );
      }

      developer.log(
        'QuizCubit: Successfully loaded ${questions.length} questions',
      );
      if (!_disposed && !isClosed) {
        emit(LoadedState(questions));
      }
    } on FirebaseException catch (e, stackTrace) {
      developer.log('QuizCubit: Firebase error: ${e.code} - ${e.message}');
      developer.log('Stack trace: $stackTrace');

      String errorMessage;

      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'Permission denied. Please check your access rights.';
          break;
        case 'not-found':
          errorMessage = 'Quiz not found. Please check the quiz ID "$quizId".';
          break;
        case 'unavailable':
          errorMessage = 'Service temporarily unavailable. Please try again.';
          break;
        case 'failed-precondition':
          errorMessage =
              'Firestore operation failed. Please check your internet connection.';
          break;
        case 'deadline-exceeded':
          errorMessage =
              'Request timed out. Please check your internet connection and try again.';
          break;
        default:
          errorMessage = 'Firebase error: ${e.message ?? e.code}';
      }

      if (!_disposed && !isClosed) {
        emit(ErrorState(errorMessage));
      }
    } catch (e, stackTrace) {
      developer.log('QuizCubit: Unexpected error: $e');
      developer.log('Stack trace: $stackTrace');

      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
      }

      if (!_disposed && !isClosed) {
        emit(ErrorState(errorMessage));
      }
    }
  }

  // Helper method to test Firestore connection
  Future<void> testFirestoreConnection() async {
    try {
      developer.log('QuizCubit: Testing Firestore connection...');

      final testSnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.teacherCollection)
          .doc()
          .collection(AppConstants.quizzesCollection)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      developer.log('QuizCubit: Firestore connection test successful');
      developer.log(
        'QuizCubit: Available quizzes count: ${testSnapshot.docs.length}',
      );

      if (testSnapshot.docs.isNotEmpty) {
        developer.log(
          'QuizCubit: Sample quiz ID: ${testSnapshot.docs.first.id}',
        );

        // Test if the first quiz has questions
        final firstQuizId = testSnapshot.docs.first.id;
        final questionsSnapshot = await FirebaseFirestore.instance
            .collection(AppConstants.teacherCollection)
            .doc()
            .collection(AppConstants.quizzesCollection)
            .doc(firstQuizId)
            .collection(AppConstants.questionsCollection)
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 10));

        developer.log(
          'QuizCubit: Sample quiz has ${questionsSnapshot.docs.length} questions',
        );
      }
    } catch (e, stackTrace) {
      developer.log('QuizCubit: Firestore connection test failed: $e');
      developer.log('Stack trace: $stackTrace');
    }
  }

  // Method to get all available quiz IDs (for debugging)
  Future<List<String>> getAvailableQuizIds() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppConstants.teacherCollection)
          .doc()
          .collection(AppConstants.quizzesCollection)
          .get()
          .timeout(const Duration(seconds: 10));

      final quizIds = snapshot.docs.map((doc) => doc.id).toList();
      developer.log('QuizCubit: Available quiz IDs: $quizIds');

      // Also check which quizzes have questions
      for (final quizId in quizIds) {
        try {
          final questionsSnapshot = await FirebaseFirestore.instance
              .collection(AppConstants.quizzesCollection)
              .doc(quizId)
              .collection(AppConstants.questionsCollection)
              .limit(1)
              .get()
              .timeout(const Duration(seconds: 5));

          developer.log(
            'QuizCubit: Quiz $quizId has ${questionsSnapshot.docs.length} questions',
          );
        } catch (e) {
          developer.log(
            'QuizCubit: Error checking questions for quiz $quizId: $e',
          );
        }
      }

      return quizIds;
    } catch (e, stackTrace) {
      developer.log('QuizCubit: Error getting available quiz IDs: $e');
      developer.log('Stack trace: $stackTrace');
      return [];
    }
  }

  // Method to retry current operation
  void retry() {
    if (state is ErrorState) {
      // You might want to store the last quizId to retry
      developer.log('QuizCubit: Retry requested');
      // emit(LoadingState()); // Uncomment if you want to show loading on retry
    }
  }
}
