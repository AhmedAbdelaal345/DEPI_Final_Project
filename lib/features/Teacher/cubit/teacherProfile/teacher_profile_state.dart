import 'package:equatable/equatable.dart';


abstract class TeacherProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileLoaded extends TeacherProfileState {
  final int totalQuizzes;
  final int totalSubjects;
  final double averageQuestions;

  TeacherProfileLoaded({
    required this.totalQuizzes,
    required this.totalSubjects,
    required this.averageQuestions,
  });

  @override
  List<Object?> get props => [totalQuizzes, totalSubjects, averageQuestions];
}

class TeacherProfileError extends TeacherProfileState {
  final String message;

  TeacherProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
