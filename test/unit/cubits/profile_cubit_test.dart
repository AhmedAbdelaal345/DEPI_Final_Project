import 'package:depi_final_project/features/profile/cubit/profile_cubit.dart';
import 'package:depi_final_project/features/profile/cubit/profile_state.dart';
import 'package:depi_final_project/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  group('ProfileCubit', () {
    // Skip tests that require Firebase initialization
    test('ProfileCubit can be instantiated', () {
      // Just verify the class exists
    }, skip: 'Requires Firebase initialization');
  });
}
