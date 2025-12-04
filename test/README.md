# Testing Guide

## Overview
This project includes comprehensive testing: unit tests, widget tests, and integration tests. Our testing strategy ensures code quality, prevents regressions, and validates user flows.

## Quick Start

### Run All Tests
```bash
flutter test
```

### Run Specific Test Types
```bash
# Unit tests only
flutter test test/unit

# Widget tests only
flutter test test/widget

# Integration tests
flutter test integration_test
```

### Generate Code Coverage
```bash
flutter test --coverage
```

### Generate Mocks
Before running tests that use mocks, generate them:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Structure

### Unit Tests (`test/unit/`)
Unit tests verify individual components in isolation.

#### Cubits (`test/unit/cubits/`)
- **`auth_cubit_test.dart`** - Authentication state management
  - Tests initial state
  - Validates login flow
  - Tests error handling
  
- **`login_cubit_test.dart`** - Login-specific state management
  - Email/password validation
  - Remember me functionality
  - Google sign-in flow
  
- **`profile_cubit_test.dart`** - User profile management
  - Profile loading states
  - Profile update operations
  
- **`quiz_cubit_test.dart`** - Quiz state management
  - Quiz loading and submission
  - Answer tracking
  - Score calculation

#### Repositories (`test/unit/repositories/`)
- **`profile_repository_test.dart`** - Profile data operations
  - User profile CRUD operations
  - Pro subscription management
  - Quiz statistics aggregation

### Widget Tests (`test/widget/`)
Widget tests verify UI components and user interactions.

#### Screens (`test/widget/screens/`)
- **`home_screen_test.dart`** - Home screen UI
  - Quiz code input validation
  - Join button functionality
  - Loading states
  - Error messages
  
- **`login_screen_test.dart`** - Login screen UI
  - Form validation
  - Email/password input
  - Error display
  - Navigation links
  
- **`quiz_history_screen_test.dart`** - Quiz history display
  - History list rendering
  - Empty state handling
  - Quiz item interactions
  
- **`wrapper_page_test.dart`** - Main navigation wrapper
  - Bottom navigation
  - Screen switching
  - Drawer functionality
  - BLoC provider setup

#### Widgets (`test/widget/widgets/`)
- **`profile_header_test.dart`** - Profile header component
  - User information display
  - PRO badge visibility
  - Animation behavior
  
- **`stat_card_test.dart`** - Statistics card component
  - Data display
  - Icon rendering
  - Layout structure

### Integration Tests (`integration_test/`)
Integration tests verify complete user flows and app behavior.

- **`complete_quiz_flow_test.dart`** - End-to-end quiz flow
  - Login to quiz completion
  - Answer submission
  - Results display
  
- **`profile_flow_test.dart`** - Profile and navigation flow
  - Profile viewing
  - Settings navigation
  - Data persistence
  
- **`app_flow_test.dart`** - General app flows
  - Authentication flow
  - Navigation between screens
  - User interactions
  - Error handling
  - App lifecycle

### Test Utilities (`test/test_utils/`)
Shared utilities for testing.

- **`firebase_mocks.dart`** - Firebase mocking setup
- **`firebase_test_setup.dart`** - Firebase test configuration
- **`pump_app.dart`** - Widget testing helpers
- **`test_data.dart`** - Sample test data

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
