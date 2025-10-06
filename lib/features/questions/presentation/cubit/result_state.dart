import 'package:depi_final_project/features/questions/presentation/model/question_model.dart';

abstract class ResultState {}

class InitState extends ResultState {}

class LoadingState extends ResultState {}

class LoadedState extends ResultState {}

class ErrorState extends ResultState {
  String error;
  ErrorState(this.error);
}
