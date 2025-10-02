import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_details_state.dart';

class RegisterDetailsCubit extends Cubit<RegisterDetailsState> {
  RegisterDetailsCubit() : super(const RegisterDetailsState());

  void register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isTeacher,
  }) {
    emit(
      state.copyWith(
        fullNameError: null,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
        
        generalError: null,
      ),
    );

    final bool isFullNameValid = _validateFullName(fullName);
    final bool isEmailValid = _validateEmail(email);
    final bool isPasswordValid = _validatePassword(password);
    final bool isConfirmPasswordValid = _validateConfirmPassword(
      password,
      confirmPassword,
    );

    if (isFullNameValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid) {
      _performRegistration();
    }
  }

  bool _validateFullName(String fullName) {
    if (fullName.isEmpty) {
      emit(state.copyWith(fullNameError: 'Please enter your full name'));
      return false;
    }
    return true;
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      emit(state.copyWith(emailError: 'Please enter your email'));
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.length < 6) {
      emit(
        state.copyWith(passwordError: 'Password must be at least 6 characters'),
      );
      return false;
    }
    return true;
  }

  bool _validatePhone(String phone) {
    if (!AppConstants.phoneRegExp.hasMatch(phone)) {
      emit(
        state.copyWith(phoneError: 'the phone number is not valid'),
      );
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      emit(state.copyWith(confirmPasswordError: 'Passwords do not match'));
      return false;
    }
    return true;
  }

  void _performRegistration() async {
    emit(state.copyWith(status: RegisterStatus.loading));

    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: RegisterStatus.success));
  }
}
