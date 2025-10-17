// features/profile/data/repositories/profile_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get user profile
  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('Student').doc(userId).get();

      if (doc.exists) {
        return UserProfileModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Stream user profile for real-time updates
  Stream<UserProfileModel?> streamUserProfile(String userId) {
    return _firestore
        .collection('Student')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfileModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    });
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('Student').doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Subscribe to Pro
  Future<bool> subscribeToPro(String userId) async {
    try {
      final now = DateTime.now();
      final expiryDate = now.add(const Duration(days: 30)); // 30 days subscription

      await _firestore.collection('Student').doc(userId).update({
        'isPro': true,
        'proSubscriptionDate': now.toIso8601String(),
        'proExpiryDate': expiryDate.toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error subscribing to Pro: $e');
      return false;
    }
  }

  // Cancel Pro subscription
  Future<bool> cancelProSubscription(String userId) async {
    try {
      await _firestore.collection('Student').doc(userId).update({
        'isPro': false,
        'proExpiryDate': null,
      });
      return true;
    } catch (e) {
      print('Error canceling Pro subscription: $e');
      return false;
    }
  }

  // Get quiz statistics
  Future<Map<String, int>> getQuizStatistics(String userId) async {
    try {
      // Query quizzes taken by user
      final quizzesSnapshot = await _firestore
          .collection('Quizzes')
          .where('userId', isEqualTo: userId)
          .get();

      int totalQuizzes = quizzesSnapshot.docs.length;

      // Calculate unique subjects
      Set<String> uniqueSubjects = {};
      int totalScore = 0;
      int quizzesWithScore = 0;

      for (var doc in quizzesSnapshot.docs) {
        final data = doc.data();
        if (data['subject'] != null) {
          uniqueSubjects.add(data['subject']);
        }
        if (data['score'] != null) {
          totalScore += (data['score'] as num).toInt();
          quizzesWithScore++;
        }
      }

      int averageScore = quizzesWithScore > 0 ? (totalScore / quizzesWithScore).round() : 0;

      return {
        'quizzesTaken': totalQuizzes,
        'subjects': uniqueSubjects.length,
        'averageScore': averageScore,
      };
    } catch (e) {
      print('Error getting quiz statistics: $e');
      return {
        'quizzesTaken': 0,
        'subjects': 0,
        'averageScore': 0,
      };
    }
  }

  // Update quiz statistics in user profile
  Future<void> updateQuizStatistics(String userId) async {
    try {
      final stats = await getQuizStatistics(userId);
      await _firestore.collection('Student').doc(userId).update(stats);
    } catch (e) {
      print('Error updating quiz statistics: $e');
    }
  }
}

