// lib/features/review_answers/presentation/cubit/review_answers_state.dart

import '../model/review_question.dart';

// الكلاس الأساسي، بدون Equatable
abstract class ReviewAnswersState {
  const ReviewAnswersState();
}

class ReviewAnswersInitial extends ReviewAnswersState {}

class ReviewAnswersLoading extends ReviewAnswersState {}

class ReviewAnswersLoaded extends ReviewAnswersState {
  final List<ReviewQuestion> questions;

  const ReviewAnswersLoaded(this.questions,);
}

class ReviewAnswersError extends ReviewAnswersState {
  final String message;

  const ReviewAnswersError(this.message);
}