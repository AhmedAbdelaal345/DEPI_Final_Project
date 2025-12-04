import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('QuizCubit', () {
    late QuizCubit quizCubit;

    setUp(() {
      quizCubit = QuizCubit();
    });

    tearDown(() {
      quizCubit.close();
    });

    test('initial state is InitState', () {
      expect(quizCubit.state, isA<InitState>());
    });

    test('dispose sets disposed flag', () {
      quizCubit.dispose();
      expect(quizCubit.isClosed, true);
    });

    group('getQuestions', () {
      blocTest<QuizCubit, QuizState>(
        'emits ErrorState when quizId is empty',
        build: () => quizCubit,
        act: (cubit) => cubit.getQuestions(''),
        expect: () => [
          isA<ErrorState>().having(
            (state) => state.error,
            'error',
            'Invalid quiz ID',
          ),
        ],
      );

      // Note: Testing with Firebase requires mocking or integration tests
      // These tests verify the basic state management logic
    });

    test('retry method can be called', () {
      expect(() => quizCubit.retry(), returnsNormally);
    });
  });
}
