// features/profile/cubit/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_state.dart';
import 'dart:async';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  StreamSubscription? _profileSubscription;
  UserProfileModel? _currentProfile;

  ProfileCubit(this._repository) : super(ProfileInitial());

  // Get current profile
  UserProfileModel? get currentProfile => _currentProfile;

  // Load user profile (one-time)
  Future<void> loadUserProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await _repository.getUserProfile(userId);
      if (profile != null) {
        _currentProfile = profile;
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError('User profile not found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  // Stream user profile (real-time updates)
  void streamUserProfile(String userId) {
    emit(ProfileLoading());
    _profileSubscription?.cancel();

    _profileSubscription = _repository.streamUserProfile(userId).listen(
      (profile) {
        if (profile != null) {
          _currentProfile = profile;
          emit(ProfileLoaded(profile));
        } else {
          emit(ProfileError('User profile not found'));
        }
      },
      onError: (error) {
        emit(ProfileError('Failed to stream profile: $error'));
      },
    );
  }

  // Update user profile
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    emit(ProfileUpdating());
    try {
      final success = await _repository.updateUserProfile(userId, data);
      if (success) {
        emit(ProfileUpdated('Profile updated successfully'));
        // Reload profile
        await loadUserProfile(userId);
      } else {
        emit(ProfileError('Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  // Subscribe to Pro
  Future<void> subscribeToPro(String userId) async {
    try {
      final success = await _repository.subscribeToPro(userId);
      if (success) {
        emit(ProSubscriptionSuccess('Successfully subscribed to Pro!'));
        // Reload profile to show Pro status
        await loadUserProfile(userId);
      } else {
        emit(ProSubscriptionError('Failed to subscribe to Pro'));
      }
    } catch (e) {
      emit(ProSubscriptionError('Failed to subscribe: $e'));
    }
  }

  // Cancel Pro subscription
  Future<void> cancelProSubscription(String userId) async {
    try {
      final success = await _repository.cancelProSubscription(userId);
      if (success) {
        emit(ProfileUpdated('Pro subscription canceled'));
        await loadUserProfile(userId);
      } else {
        emit(ProfileError('Failed to cancel subscription'));
      }
    } catch (e) {
      emit(ProfileError('Failed to cancel subscription: $e'));
    }
  }

  // Update quiz statistics
  Future<void> updateQuizStatistics(String userId) async {
    try {
      await _repository.updateQuizStatistics(userId);
      await loadUserProfile(userId);
    } catch (e) {
      print('Failed to update statistics: $e');
    }
  }

  // Refresh profile
  Future<void> refreshProfile(String userId) async {
    await loadUserProfile(userId);
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}

