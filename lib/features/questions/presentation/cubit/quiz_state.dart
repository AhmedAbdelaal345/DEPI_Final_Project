import 'package:depi_final_project/features/questions/presentation/model/question_model.dart';

abstract class QuizState {}

class InitState extends QuizState {}

class LoadingState extends QuizState {}

class LoadedState extends QuizState {
  List<QuestionModel> questions;

  LoadedState(this.questions,);
}

class ErrorState extends QuizState {
  String error;
  ErrorState(this.error);
}
