// features/profile/data/repositories/firebase_setup_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSetupHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize user profile in Firebase when user signs up
  static Future<void> createUserProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phone,
  }) async {
    try {
      await _firestore.collection('Student').doc(userId).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'profileImageUrl': null,
        'isPro': false,
        'proSubscriptionDate': null,
        'proExpiryDate': null,
        'quizzesTaken': 0,
        'subjects': 0,
        'averageScore': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ User profile created successfully');
    } catch (e) {
      print('❌ Error creating user profile: $e');
      rethrow;
    }
  }

  /// Check if user profile exists
  static Future<bool> userProfileExists(String userId) async {
    try {
      final doc = await _firestore.collection('Student').doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user profile: $e');
      return false;
    }
  }

  /// Migrate existing user to new profile structure
  static Future<void> migrateUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('Student').doc(userId).get();

      if (doc.exists) {
        final data = doc.data()!;

        // Add missing fields if they don't exist
        Map<String, dynamic> updates = {};

        if (!data.containsKey('isPro')) {
          updates['isPro'] = false;
        }
        if (!data.containsKey('quizzesTaken')) {
          updates['quizzesTaken'] = 0;
        }
        if (!data.containsKey('subjects')) {
          updates['subjects'] = 0;
        }
        if (!data.containsKey('averageScore')) {
          updates['averageScore'] = 0;
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('Student').doc(userId).update(updates);
          print('✅ User profile migrated successfully');
        }
      }
    } catch (e) {
      print('❌ Error migrating user profile: $e');
    }
  }

  /// Test Firebase connection and permissions
  static Future<bool> testFirebaseConnection() async {
    try {
      await _firestore.collection('_test').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore.collection('_test').doc('test').delete();
      print('✅ Firebase connection successful');
      return true;
    } catch (e) {
      print('❌ Firebase connection failed: $e');
      return false;
    }
  }
}

