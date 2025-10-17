// features/profile/cubit/profile_state.dart
import '../data/models/user_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfile;

  ProfileLoaded(this.userProfile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final String message;

  ProfileUpdated(this.message);
}

class ProSubscriptionSuccess extends ProfileState {
  final String message;

  ProSubscriptionSuccess(this.message);
}

class ProSubscriptionError extends ProfileState {
  final String message;

  ProSubscriptionError(this.message);
}

