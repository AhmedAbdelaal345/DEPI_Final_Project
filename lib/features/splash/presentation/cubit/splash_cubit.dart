import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:depi_final_project/core/services/auth_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthService _authService = AuthService();

  SplashCubit() : super(SplashInitial());

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    await _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      // Check if user is logged in from SharedPreferences
      final isLoggedIn = await _authService.isLoggedIn();

      if (!isLoggedIn) {
        // User not logged in, go to onboarding
        emit(SplashNavigateToOnboarding());
        return;
      }

      // Check if Firebase user is still authenticated
      final isFirebaseAuth = await _authService.isFirebaseUserAuthenticated();

      if (!isFirebaseAuth) {
        // Firebase session expired, clear local data and go to onboarding
        await _authService.clearLoginState();
        emit(SplashNavigateToOnboarding());
        return;
      }

      // Get saved user type
      final userType = await _authService.getSavedUserType();

      if (userType == null) {
        // No user type saved, check from Firestore
        final currentUser = _authService.getCurrentUser();
        if (currentUser != null) {
          final checkedUserType = await _authService.checkUserType(currentUser.uid);
          if (checkedUserType != null) {
            // Save the user type and navigate
            await _authService.saveLoginState(
              userId: currentUser.uid,
              userType: checkedUserType,
            );
            _navigateBasedOnUserType(checkedUserType);
          } else {
            // User type not found, clear and go to onboarding
            await _authService.clearLoginState();
            emit(SplashNavigateToOnboarding());
          }
        } else {
          emit(SplashNavigateToOnboarding());
        }
      } else {
        // User type exists, navigate directly
        _navigateBasedOnUserType(userType);
      }
    } catch (e) {
      print('Error checking auth state: $e');
      // On error, go to onboarding
      emit(SplashNavigateToOnboarding());
    }
  }

  void _navigateBasedOnUserType(String userType) {
    if (userType == 'student') {
      emit(SplashNavigateToStudent());
    } else if (userType == 'teacher') {
      emit(SplashNavigateToTeacher());
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
