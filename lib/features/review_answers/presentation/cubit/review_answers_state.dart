// lib/features/review_answers/presentation/cubit/review_answers_state.dart

import '../../domain/entities/review_question.dart';

// الكلاس الأساسي، بدون Equatable
abstract class ReviewAnswersState {
  const ReviewAnswersState();
}

// الحالة الأولية
class ReviewAnswersInitial extends ReviewAnswersState {}

// حالة التحميل
class ReviewAnswersLoading extends ReviewAnswersState {}

// حالة النجاح في جلب البيانات
class ReviewAnswersLoaded extends ReviewAnswersState {
  final List<ReviewQuestion> questions;

  const ReviewAnswersLoaded(this.questions);
}

// حالة حدوث خطأ
class ReviewAnswersError extends ReviewAnswersState {
  final String message;

  const ReviewAnswersError(this.message);
}