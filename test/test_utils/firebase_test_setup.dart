import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Sets up Firebase for testing
/// Call this in the main() function of your test files before running tests
Future<void> setupFirebaseForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up method channel mocking for Firebase
  setupFirebaseAuthMocks();
  setupFirestoreMocks();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-sender-id',
        projectId: 'test-project-id',
      ),
    );
  } catch (e) {
    // Firebase already initialized, ignore
  }
}

/// Mock Firebase Auth method channels
void setupFirebaseAuthMocks() {
  const MethodChannel('plugins.flutter.io/firebase_auth')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Auth#registerChangeListener':
        return {'user': null};
      case 'Auth#signInAnonymously':
        return {
          'user': {
            'uid': 'test-uid',
            'email': 'test@example.com',
            'isAnonymous': true,
          }
        };
      default:
        return null;
    }
  });
}

/// Mock Firestore method channels
void setupFirestoreMocks() {
  const MethodChannel('plugins.flutter.io/cloud_firestore')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Query#snapshots':
        return {'documents': []};
      case 'DocumentReference#get':
        return {'data': {}};
      default:
        return null;
    }
  });
}
