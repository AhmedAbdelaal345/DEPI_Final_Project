import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyUserType = 'userType'; // 'student' or 'teacher'

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save login state
  Future<void> saveLoginState({
    required String userId,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserType, userType);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get saved user ID
  Future<String?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Get saved user type
  Future<String?> getSavedUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  // Clear login state (logout)
  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserType);
    await _auth.signOut();
  }

  // Sign out method
  Future<void> signOut() async {
    await clearLoginState();
  }

  // Check user type from Firestore
  Future<String?> checkUserType(String uid) async {
    try {
      // Check if user is a student
      DocumentSnapshot studentDoc =
          await _firestore.collection('Student').doc(uid).get();
      if (studentDoc.exists) {
        return 'student';
      }

      // Check if user is a teacher
      DocumentSnapshot teacherDoc =
          await _firestore.collection('teacher').doc(uid).get();
      if (teacherDoc.exists) {
        return 'teacher';
      }

      return null;
    } catch (e) {
      print('Error checking user type: $e');
      return null;
    }
  }

  // Get current Firebase user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if Firebase user is still authenticated
  Future<bool> isFirebaseUserAuthenticated() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Reload user to check if still valid
      await user.reload();
      return _auth.currentUser != null;
    } catch (e) {
      print('Error checking Firebase authentication: $e');
      return false;
    }
  }
}
