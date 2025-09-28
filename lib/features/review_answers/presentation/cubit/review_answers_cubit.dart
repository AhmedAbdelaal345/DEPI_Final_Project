// lib/features/review_answers/presentation/cubit/review_answers_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/review_repository.dart';
import 'review_answers_state.dart';

class ReviewAnswersCubit extends Cubit<ReviewAnswersState> {
  final ReviewRepository reviewRepository;

  ReviewAnswersCubit(this.reviewRepository) : super(ReviewAnswersInitial());

  // وظيفة لجلب الإجابات الخاطئة
  Future<void> fetchWrongAnswers() async {
    try {
      emit(ReviewAnswersLoading());
      final questions = await reviewRepository.getWrongAnswers();
      emit(ReviewAnswersLoaded(questions));
    } catch (e) {
      emit(ReviewAnswersError('Failed to fetch wrong answers.'));
    }
  }

  // وظيفة لجلب الإجابات الصحيحة
  Future<void> fetchCorrectAnswers() async {
    try {
      emit(ReviewAnswersLoading());
      final questions = await reviewRepository.getCorrectAnswers();
      emit(ReviewAnswersLoaded(questions));
    } catch (e) {
      emit(ReviewAnswersError('Failed to fetch correct answers.'));
    }
  }
}