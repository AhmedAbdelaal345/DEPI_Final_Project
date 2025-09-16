
enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool rememberMe;

  const LoginState({
    this.status = LoginStatus.initial,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.rememberMe = false,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? rememberMe,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

