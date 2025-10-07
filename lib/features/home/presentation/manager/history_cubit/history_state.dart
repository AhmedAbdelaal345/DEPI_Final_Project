import 'package:depi_final_project/features/home/presentation/model/history_model.dart';

abstract class HistoryState {}

class InitialState extends HistoryState {}

class LoadedState extends HistoryState {
  Map<String, List<QuizHistoryModel>> groupedQuizzes;
  LoadedState(this.groupedQuizzes);
}

class LoadingState extends HistoryState {}

class EmptyState extends HistoryState {}

class ErrorState extends HistoryState {
  String error;
  ErrorState(this.error);
}
