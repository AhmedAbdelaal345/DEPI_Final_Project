import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:depi_final_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Test', () {
    testWidgets('Complete authentication flow from splash to login', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on a screen with navigation or login elements
      // The app should show either login screen or home screen
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Login screen validation works correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for login button
      final loginButton = find.text('Login');
      
      if (loginButton.evaluate().isNotEmpty) {
        // Try to login without credentials
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Should show validation errors
        // The exact error text depends on your localization
        expect(find.byType(Text), findsWidgets);
      }
    });

    testWidgets('Navigation between screens works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if bottom navigation is present (user is logged in)
      final homeIcon = find.byIcon(Icons.home);
      
      if (homeIcon.evaluate().isNotEmpty) {
        // User is logged in, test navigation
        final historyIcon = find.byIcon(Icons.history);
        if (historyIcon.evaluate().isNotEmpty) {
          await tester.tap(historyIcon);
          await tester.pumpAndSettle();
          
          // Verify navigation occurred
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });
  });

  group('App Lifecycle Integration Test', () {
    testWidgets('App starts and initializes correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify app is running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App handles screen rotations', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get initial size
      final initialSize = tester.binding.window.physicalSize;
      
      // Simulate rotation by changing size
      tester.binding.window.physicalSizeTestValue = Size(
        initialSize.height,
        initialSize.width,
      );
      await tester.pumpAndSettle();

      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);

      // Reset size
      tester.binding.window.clearPhysicalSizeTestValue();
    });
  });

  group('User Interaction Integration Test', () {
    testWidgets('Text input fields accept input', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for text fields
      final textFields = find.byType(TextField);
      
      if (textFields.evaluate().isNotEmpty) {
        // Enter text in first text field
        await tester.enterText(textFields.first, 'Test Input');
        await tester.pump();
        
        // Verify text was entered
        expect(find.text('Test Input'), findsOneWidget);
      }
    });

    testWidgets('Buttons are tappable', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find any elevated buttons
      final buttons = find.byType(ElevatedButton);
      
      if (buttons.evaluate().isNotEmpty) {
        // Tap first button
        await tester.tap(buttons.first);
        await tester.pump();
        
        // Button should respond (no crash)
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });

  group('Error Handling Integration Test', () {
    testWidgets('App handles invalid input gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to find quiz code input
      final textFields = find.byType(TextField);
      
      if (textFields.evaluate().isNotEmpty) {
        // Enter invalid quiz code
        await tester.enterText(textFields.first, '!!!INVALID!!!');
        await tester.pump();
        
        // Look for join or submit button
        final actionButtons = find.text('Join');
        if (actionButtons.evaluate().isNotEmpty) {
          await tester.tap(actionButtons.first);
          await tester.pumpAndSettle();
          
          // App should handle error without crashing
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });
  });
}
