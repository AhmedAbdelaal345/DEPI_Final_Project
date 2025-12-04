import 'package:depi_final_project/features/auth/cubit/auth_cubit.dart';
import 'package:depi_final_project/features/auth/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  group('AuthCubit', () {
    late AuthCubit authCubit;

    setUp(() {
      authCubit = AuthCubit();
    });

    tearDown(() {
      authCubit.close();
    });

    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    // Skip Firebase-dependent tests for now
    // These tests require Firebase to be fully initialized
    test('userHaveLogin can be called', () {
      // Just verify the method exists and can be called
      expect(() => authCubit.userHaveLogin(), returnsNormally);
    }, skip: 'Requires Firebase initialization');
  });
}
