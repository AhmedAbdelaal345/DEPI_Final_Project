abstract class ResultState {}

class InitState extends ResultState {}

class LoadingState extends ResultState {}

class LoadedState extends ResultState {}

class ErrorState extends ResultState {
  final String message;
  ErrorState(this.message);
}
