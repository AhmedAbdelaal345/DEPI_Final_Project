enum RegisterStatus { initial, loading, success, failure }

class RegisterDetailsState {
  final RegisterStatus status;

  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? phoneError;
  final String? generalError;

  const RegisterDetailsState({
    this.status = RegisterStatus.initial,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.generalError,
    this.phoneError
  });

  RegisterDetailsState copyWith({
    RegisterStatus? status,
    String? fullNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? generalError,
    String? phoneError,
  }) {
    return RegisterDetailsState(
      status: status ?? this.status,
      fullNameError: fullNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      generalError: generalError,
      phoneError: phoneError ?? this.phoneError,
    );
  }
}
