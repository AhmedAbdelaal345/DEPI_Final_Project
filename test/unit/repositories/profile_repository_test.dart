import 'package:depi_final_project/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  group('ProfileRepository', () {
    late ProfileRepository repository;

    setUp(() {
      repository = ProfileRepository();
    });

    test('can be instantiated', () {
      expect(repository, isNotNull);
      expect(repository, isA<ProfileRepository>());
    });

    test('currentUserId returns null when no user is logged in', () {
      expect(repository.currentUserId, isNull);
    });

    group('getUserProfile', () {
      test('returns null when user does not exist', () async {
        final result = await repository.getUserProfile('non-existent-user');
        expect(result, isNull);
      });

      test('handles errors gracefully', () async {
        // Test with invalid user ID
        final result = await repository.getUserProfile('');
        expect(result, isNull);
      });
    });

    group('updateUserProfile', () {
      test('returns false when update fails with invalid user', () async {
        final result = await repository.updateUserProfile(
          'non-existent-user',
          {'name': 'Test User'},
        );
        expect(result, isFalse);
      });

      test('handles empty data map', () async {
        final result = await repository.updateUserProfile(
          'test-user',
          {},
        );
        // Should not throw an error
        expect(result, isA<bool>());
      });
    });

    group('subscribeToPro', () {
      test('returns false when subscription fails', () async {
        final result = await repository.subscribeToPro(
          'non-existent-user',
          'Test User',
        );
        expect(result, isFalse);
      });

      test('handles empty user ID', () async {
        final result = await repository.subscribeToPro('', 'Test User');
        expect(result, isFalse);
      });
    });

    group('cancelProSubscription', () {
      test('returns false when cancellation fails', () async {
        final result = await repository.cancelProSubscription('non-existent-user');
        expect(result, isFalse);
      });

      test('handles empty user ID', () async {
        final result = await repository.cancelProSubscription('');
        expect(result, isFalse);
      });
    });

    group('getQuizStatistics', () {
      test('returns default statistics when user has no quizzes', () async {
        final result = await repository.getQuizStatistics('non-existent-user');
        
        expect(result, isA<Map<String, int>>());
        expect(result['quizzesTaken'], 0);
        expect(result['subjects'], 0);
        expect(result['averageScore'], 0);
      });

      test('handles empty user ID', () async {
        final result = await repository.getQuizStatistics('');
        
        expect(result, isA<Map<String, int>>());
        expect(result['quizzesTaken'], 0);
      });

      test('returns map with correct keys', () async {
        final result = await repository.getQuizStatistics('test-user');
        
        expect(result.containsKey('quizzesTaken'), isTrue);
        expect(result.containsKey('subjects'), isTrue);
        expect(result.containsKey('averageScore'), isTrue);
      });
    });

    group('updateQuizStatistics', () {
      test('completes without error for non-existent user', () async {
        // Should not throw
        await repository.updateQuizStatistics('non-existent-user');
      });

      test('handles empty user ID', () async {
        // Should not throw
        await repository.updateQuizStatistics('');
      });
    });

    group('streamUserProfile', () {
      test('returns a stream', () {
        final stream = repository.streamUserProfile('test-user');
        expect(stream, isA<Stream>());
      });

      test('stream can be listened to', () async {
        final stream = repository.streamUserProfile('test-user');
        
        // Should not throw when listening
        final subscription = stream.listen((_) {});
        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();
      });
    });
  });
}
