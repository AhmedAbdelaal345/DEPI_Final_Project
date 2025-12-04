# Quick Testing Reference

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/cubits/login_cubit_test.dart
```

### Run Tests in a Directory
```bash
flutter test test/unit
flutter test test/widget
flutter test integration_test
```

### Run with Coverage
```bash
flutter test --coverage
```

### Run with Verbose Output
```bash
flutter test -r expanded
```

## Test File Locations

### Unit Tests
```
test/unit/
├── cubits/
│   ├── auth_cubit_test.dart
│   ├── login_cubit_test.dart
│   ├── profile_cubit_test.dart
│   └── quiz_cubit_test.dart
└── repositories/
    └── profile_repository_test.dart
```

### Widget Tests
```
test/widget/
├── screens/
│   ├── home_screen_test.dart
│   ├── login_screen_test.dart
│   ├── quiz_history_screen_test.dart
│   └── wrapper_page_test.dart
└── widgets/
    ├── profile_header_test.dart
    └── stat_card_test.dart
```

### Integration Tests
```
integration_test/
├── app_flow_test.dart
├── complete_quiz_flow_test.dart
└── profile_flow_test.dart
```

## Common Commands

### Generate Mocks
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter test
```

### Run Single Test
```bash
flutter test test/unit/cubits/login_cubit_test.dart --name "initial state"
```

## Test Patterns

### Unit Test Pattern
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
      expect(cubit.state.property, expectedValue);
    });

    blocTest<MyCubit, MyState>(
      'description of what it tests',
      build: () => MyCubit(),
      act: (cubit) => cubit.someMethod(),
      verify: (cubit) {
        expect(cubit.state.property, expectedValue);
      },
    );
  });
}
```

### Widget Test Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('widget description', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyWidget(),
      ),
    );

    expect(find.text('Expected Text'), findsOneWidget);
    expect(find.byType(MyWidget), findsOneWidget);
  });
}
```

### Integration Test Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Interact with UI
    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();

    // Verify results
    expect(find.text('Result'), findsOneWidget);
  });
}
```

## Troubleshooting

### Test Fails with Firebase Error
- Ensure `setupFirebaseMocks()` is called
- Check `test/test_utils/firebase_mocks.dart`

### Widget Not Found
- Use `await tester.pumpAndSettle()` to wait for animations
- Check if widget is in the correct context
- Verify widget is actually rendered

### Timeout Errors
- Increase wait duration in `pumpAndSettle(Duration(seconds: X))`
- Check for infinite animations
- Verify async operations complete

### BLoC Provider Not Found
- Ensure widget is wrapped with BLoC providers
- Use test utilities from `test/test_utils/pump_app.dart`

## Best Practices

✅ **DO**
- Write descriptive test names
- Test one thing per test
- Use setUp and tearDown
- Mock external dependencies
- Test edge cases
- Keep tests fast

❌ **DON'T**
- Test implementation details
- Make tests dependent on each other
- Use real Firebase in unit tests
- Ignore failing tests
- Write flaky tests

## Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: Cover all user-facing components
- **Integration Tests**: Cover critical user flows

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [Test README](./README.md)
- [Testing Summary](./TESTING_SUMMARY.md)
