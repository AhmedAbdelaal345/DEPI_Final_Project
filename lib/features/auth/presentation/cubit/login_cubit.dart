import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void rememberMeChanged(bool? newValue) {
    emit(state.copyWith(rememberMe: newValue ?? false));
  }

  void login({
    required String email,
    required String password,
  }) {

    emit(state.copyWith(emailError: null, passwordError: null, generalError: null));


    final bool isEmailValid = _validateEmail(email);
    final bool isPasswordValid = _validatePassword(password);

    if (isEmailValid && isPasswordValid) {

      _performLogin(rememberMe: state.rememberMe);
    }
  }


  bool _validateEmail(String email) {
    if (email.isEmpty) {
      emit(state.copyWith(emailError: 'Please enter your email'));
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: 'Please enter your password'));
      return false;
    }
    return true;
  }

  void _performLogin({required bool rememberMe}) async {
    emit(state.copyWith(status: LoginStatus.loading));
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: LoginStatus.success));
  }
}
