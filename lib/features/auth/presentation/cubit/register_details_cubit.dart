import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_details_state.dart';

class RegisterDetailsCubit extends Cubit<RegisterDetailsState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RegisterDetailsCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(const RegisterDetailsState());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isTeacher,
    String? phone,
  }) async {
    // Clear previous errors
    emit(
      state.copyWith(
        fullNameError: null,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
        phoneError: null,
        generalError: null,
      ),
    );

    // Validate inputs
    final bool isFullNameValid = _validateFullName(fullName);
    final bool isEmailValid = _validateEmail(email);
    final bool isPasswordValid = _validatePassword(password);
    final bool isConfirmPasswordValid = _validateConfirmPassword(
      password,
      confirmPassword,
    );
    final bool isPhoneValid = phone == null || phone.isEmpty || _validatePhone(phone);

    if (isFullNameValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        isPhoneValid) {
      await _performRegistration(
        fullName: fullName,
        email: email,
        password: password,
        isTeacher: isTeacher,
        phone: phone,
      );
    }
  }

  bool _validateFullName(String fullName) {
    if (fullName.isEmpty) {
      emit(state.copyWith(fullNameError: 'Please enter your full name'));
      return false;
    }
    if (fullName.length < 3) {
      emit(state.copyWith(fullNameError: 'Name must be at least 3 characters'));
      return false;
    }
    return true;
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      emit(state.copyWith(emailError: 'Please enter your email'));
      return false;
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emit(state.copyWith(emailError: 'Please enter a valid email'));
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password == "GoogleSignIn") {
      return true;
    }
    if (password.isEmpty) {
      emit(state.copyWith(passwordError: 'Please enter a password'));
      return false;
    }
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
        state.copyWith(phoneError: 'The phone number is not valid'),
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

  Future<void> _performRegistration({
    required String fullName,
    required String email,
    required String password,
    required bool isTeacher,
    String? phone,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      User? user;
      
      // Check if this is a Google sign-in (user already authenticated)
      if (password == "GoogleSignIn") {
        user = _auth.currentUser;
      } else {
        // Create new user with email and password
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        user = userCredential.user;
      }

      if (user != null) {
        // Update display name
        await user.updateDisplayName(fullName);

        // Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'isTeacher': isTeacher,
          'phone': phone ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'profilePicture': user.photoURL ?? '',
        });

        emit(state.copyWith(status: RegisterStatus.success));
      } else {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            generalError: 'Failed to register user',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          emit(state.copyWith(
            status: RegisterStatus.failure,
            passwordError: errorMessage,
          ));
          return;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email';
          emit(state.copyWith(
            status: RegisterStatus.failure,
            emailError: errorMessage,
          ));
          return;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          emit(state.copyWith(
            status: RegisterStatus.failure,
            emailError: errorMessage,
          ));
          return;
        default:
          errorMessage = e.message ?? 'Registration failed';
      }
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          generalError: errorMessage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          generalError: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  void reset() {
    emit(const RegisterDetailsState());
  }
}