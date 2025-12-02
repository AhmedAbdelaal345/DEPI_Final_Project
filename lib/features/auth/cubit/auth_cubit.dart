// features/auth/presentation/cubit/auth_cubit.dart
import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  StreamSubscription<User?>? _sub;

  AuthCubit() : super(AuthInitial());

  void userHaveLogin() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(AuthUnauthenticated());
        log("User is currently signed out!");
      } else {
        emit(AuthAuthenticated());
        log("User is currently signed In!");
      }
    }, onError: (e) {
      log('Auth listener error: $e');
      emit(AuthUnauthenticated());
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
