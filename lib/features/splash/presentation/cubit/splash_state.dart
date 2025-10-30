part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashNavigateToLogin extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToStudent extends SplashState {}

class SplashNavigateToTeacher extends SplashState {}
