# Testing Guide

## Overview
This project includes comprehensive testing: unit tests, widget tests, and integration tests.

## Running Tests

### All Tests
```bash
flutter test
```

### Unit Tests Only
```bash
flutter test test/unit
```

### Widget Tests Only
```bash
flutter test test/widget
```

### Integration Tests
```bash
flutter test integration_test
```

### With Coverage
```bash
flutter test --coverage
```

## Generate Mocks
Before running tests that use mocks, generate them:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Structure

### Unit Tests (`test/unit/`)
- **cubits/**: Tests for BLoC cubits
  - `auth_cubit_test.dart` - Authentication state management
  - `profile_cubit_test.dart` - User profile management
  - `quiz_cubit_test.dart` - Quiz state management

### Widget Tests (`test/widget/`)
- **screens/**: Tests for full screens
  - `home_screen_test.dart` - Home screen UI
  - `quiz_history_screen_test.dart` - Quiz history display
- **widgets/**: Tests for reusable components
  - `stat_card_test.dart` - Statistics card component

### Integration Tests (`integration_test/`)
- `complete_quiz_flow_test.dart` - End-to-end quiz flow
- `profile_flow_test.dart` - Profile and navigation flow

### Test Utilities (`test/test_utils/`)
- `pump_app.dart` - Helper to wrap widgets with providers
- `test_data.dart` - Sample test data

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('MyCubit', () {
    late MyCubit cubit;

    setUp(() {
      cubit = MyCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, isA<InitialState>());
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import '../test_utils/pump_app.dart';

void main() {
  testWidgets('MyWidget displays correctly', (tester) async {
    await tester.pumpWidget(pumpSimpleApp(MyWidget()));
    
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

## Tips
- Run `flutter pub get` after adding new test dependencies
- Use `pumpApp()` helper for widgets that need BLoC providers
- Use `pumpSimpleApp()` for simple widgets without providers
- Mock external dependencies (Firebase, HTTP, etc.)
- Keep tests fast and isolated
