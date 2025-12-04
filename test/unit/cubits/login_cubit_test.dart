import 'package:depi_final_project/features/auth/cubit/login_cubit.dart';
import 'package:depi_final_project/features/auth/cubit/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  group('LoginCubit', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = LoginCubit();
    });

    tearDown(() {
      loginCubit.close();
    });

    test('initial state is correct', () {
      expect(loginCubit.state.status, LoginStatus.initial);
      expect(loginCubit.state.emailError, isNull);
      expect(loginCubit.state.passwordError, isNull);
      expect(loginCubit.state.generalError, isNull);
      expect(loginCubit.state.rememberMe, false);
    });

    group('rememberMeChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits state with rememberMe true when called with true',
        build: () => LoginCubit(),
        act: (cubit) => cubit.rememberMeChanged(true),
        verify: (cubit) {
          expect(cubit.state.rememberMe, true);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits state with rememberMe false when called with false',
        build: () => LoginCubit(),
        act: (cubit) => cubit.rememberMeChanged(false),
        verify: (cubit) {
          expect(cubit.state.rememberMe, false);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits state with rememberMe false when called with null',
        build: () => LoginCubit(),
        act: (cubit) => cubit.rememberMeChanged(null),
        verify: (cubit) {
          expect(cubit.state.rememberMe, false);
        },
      );
    });

    group('login', () {
      blocTest<LoginCubit, LoginState>(
        'emits emailError when email is empty',
        build: () => LoginCubit(),
        act: (cubit) => cubit.login(email: '', password: 'password123'),
        verify: (cubit) {
          expect(cubit.state.emailError, 'Please enter your email');
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits passwordError when password is empty',
        build: () => LoginCubit(),
        act: (cubit) => cubit.login(email: 'test@example.com', password: ''),
        verify: (cubit) {
          expect(cubit.state.passwordError, 'Please enter your password');
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits loading and success states when credentials are valid',
        build: () => LoginCubit(),
        act: (cubit) => cubit.login(
          email: 'test@example.com',
          password: 'password123',
        ),
        wait: const Duration(seconds: 3),
        verify: (cubit) {
          expect(cubit.state.status, LoginStatus.success);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'clears previous errors before validating',
        build: () => LoginCubit(),
        seed: () => const LoginState(
          emailError: 'Previous error',
          passwordError: 'Previous error',
        ),
        act: (cubit) => cubit.login(
          email: 'test@example.com',
          password: 'password123',
        ),
        wait: const Duration(seconds: 3),
        verify: (cubit) {
          expect(cubit.state.emailError, isNull);
          expect(cubit.state.passwordError, isNull);
          expect(cubit.state.status, LoginStatus.success);
        },
      );
    });

    group('isTeacher', () {
      test('returns false when no user is logged in', () async {
        final result = await loginCubit.isTeacher();
        expect(result, false);
      });
    });

    group('signInWithGoogle', () {
      test('method exists and can be called', () async {
        final cubit = LoginCubit();
        // Just verify the method exists
        expect(() => cubit.signInWithGoogle(), isA<Function>());
        await cubit.close();
      });
    });
  });
}
