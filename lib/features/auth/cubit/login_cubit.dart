
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void rememberMeChanged(bool? newValue) {
    emit(state.copyWith(rememberMe: newValue ?? false));
  }

  Future<bool> isTeacher() async {
    try {
      User? credentials = FirebaseAuth.instance.currentUser;
      if (credentials == null) return false;

      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('teacher')
              .doc(credentials.uid)
              .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if user is teacher: $e');
      return false;
    }
  }

  void login({required String email, required String password}) {
    emit(
      state.copyWith(emailError: null, passwordError: null, generalError: null),
    );

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

  // TODO: Fix Google Sign-In implementation for google_sign_in 7.2.0
  // The API has changed and needs to be updated
  // For now, this method is commented out to allow tests to run
  Future<UserCredential> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));
    
    // Temporary: Return error until Google Sign-In is properly implemented
    emit(state.copyWith(
      status: LoginStatus.failure,
      generalError: 'Google Sign-In is temporarily unavailable. Please use email/password login.',
    ));
    throw UnimplementedError('Google Sign-In needs to be updated for the current package version');
    
    /* Original implementation - needs updating for google_sign_in 7.2.0
    try {
      // Trigger the authentication flow with proper initialization
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      if (googleUser == null) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          generalError: 'Google sign-in was cancelled',
        ));
        throw Exception('Google sign-in was cancelled');
      }
      
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential - use the correct property names
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Once signed in, return the UserCredential
      emit(state.copyWith(status: LoginStatus.success));
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          generalError: 'An error occurred during Google sign-in: $e',
        ),
      );
      rethrow;
    }
    */
  }
}
