// features/home/manager/history_cubit/history_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/history_model.dart';
import 'history_state.dart';
import '../../data/repositories/history_repository.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository repository;

  HistoryCubit(this.repository) : super(InitialState());

  Map<String, List<QuizHistoryModel>> get groupedQuizzes {
    final s = state;
    if (s is LoadedState) return s.groupedQuizzes;
    return {};
  }

  List<QuizHistoryModel> get allQuizzes {
    return groupedQuizzes.values.expand((e) => e).toList();
  }

  Future<void> getQuizzesForStudent(String uidForStudent, {bool forceRefresh = false}) async {
    emit(LoadingState());
    try {
      final quizzes = await repository.getStudentQuizzes(uidForStudent, forceRefresh: forceRefresh);
      if (quizzes.isEmpty) {
        emit(EmptyState());
        return;
      }

      final Map<String, List<QuizHistoryModel>> grouped = {};
      for (final q in quizzes) {
        final subject = _extractSubjectFromQuizId(q.quizId);
        grouped.putIfAbsent(subject, () => []).add(q);
      }

      emit(LoadedState(grouped, quizzes.length));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> refresh(String uidForStudent) async {
    await getQuizzesForStudent(uidForStudent, forceRefresh: true);
  }
}

String _extractSubjectFromQuizId(String quizId) {
  if (quizId.contains('_')) {
    String subject = quizId.split('_')[0];
    if (subject.isEmpty) return 'General';
    return subject[0].toUpperCase() + subject.substring(1);
  }
  String subject = quizId.replaceAll(RegExp(r'[0-9]'), '').trim();
  if (subject.isEmpty) return 'General';
  return subject[0].toUpperCase() + subject.substring(1);
}
