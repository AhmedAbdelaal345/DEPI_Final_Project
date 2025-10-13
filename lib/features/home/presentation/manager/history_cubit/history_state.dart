import 'package:depi_final_project/features/home/presentation/model/history_model.dart';

abstract class HistoryState {}

class InitialState extends HistoryState {}

class LoadingState extends HistoryState {}

class EmptyState extends HistoryState {}

class ErrorState extends HistoryState {
  final String error;
  ErrorState(this.error);
}

class LoadedState extends HistoryState {
  final Map<String, List<QuizHistoryModel>> groupedQuizzes;
  final int totalQuizzes;

  LoadedState(this.groupedQuizzes, this.totalQuizzes);
}
