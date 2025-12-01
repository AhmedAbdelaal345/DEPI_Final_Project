import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/features/Teacher/cubit/teacherProfile/teacher_profile_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  TeacherProfileCubit() : super(TeacherProfileLoading());

  final _firestore = FirebaseFirestore.instance;

  Future<void> loadTeacher(String teacherId) async {
    emit(TeacherProfileLoading());

    try {
      final quizRef = _firestore
          .collection(AppConstants.teacherCollection)
          .doc(teacherId)
          .collection(AppConstants.quizzesCollection);

      final quizSnapshot = await quizRef.get();
      final quizzes = quizSnapshot.docs;

      final totalQuizzes = quizzes.length;
      final subjects =
          quizzes
              .map((doc) => doc[AppConstants.subject])
              .where((s) => s != null)
              .toSet()
              .length;

      double totalQuestions = 0;

      for (var quiz in quizzes) {
        final qSnapshot =
            await quizRef
                .doc(quiz.id)
                .collection(AppConstants.questionsCollection)
                .get();

        totalQuestions += qSnapshot.size;
      }

      final avgQuestions =
          totalQuizzes == 0 ? 0 : totalQuestions / totalQuizzes;

      emit(
        TeacherProfileLoaded(
          totalQuizzes: totalQuizzes,
          totalSubjects: subjects,
          averageQuestions: avgQuestions.toDouble(),
        ),
      );
    } catch (e) {
      emit(TeacherProfileError('Failed to load teacher data'));
    }
  }
}
