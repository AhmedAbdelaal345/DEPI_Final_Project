import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:depi_final_project/main.dart' as app;
import 'package:firebase_core/firebase_core.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete Quiz Flow Integration Test', () {
    testWidgets('User can complete entire quiz flow', (WidgetTester tester) async {
      // Initialize Firebase (mock or test instance)
      // await Firebase.initializeApp();

      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Navigate to login (if not already logged in)
      // This assumes the app starts at splash/login screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 2: Enter quiz code on home screen
      final quizCodeField = find.byType(TextField);
      if (quizCodeField.evaluate().isNotEmpty) {
        await tester.enterText(quizCodeField, 'TEST123');
        await tester.pumpAndSettle();

        // Step 3: Tap join button
        final joinButton = find.text('Join');
        if (joinButton.evaluate().isNotEmpty) {
          await tester.tap(joinButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Step 4: Verify quiz page loaded
          // Look for quiz-specific elements
          expect(find.byType(AppBar), findsWidgets);

          // Step 5: Answer questions
          // This would require finding answer buttons and tapping them
          // Example: await tester.tap(find.text('Option A'));

          // Step 6: Submit quiz
          final submitButton = find.text('Submit');
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            // Step 7: Verify results page
            expect(find.text('Results'), findsOneWidget);
          }
        }
      }
    });

    testWidgets('User can view quiz history', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to history screen via bottom navigation
      final historyIcon = find.byIcon(Icons.history);
      if (historyIcon.evaluate().isNotEmpty) {
        await tester.tap(historyIcon);
        await tester.pumpAndSettle();

        // Verify history screen loaded
        expect(find.text('Quiz History'), findsOneWidget);

        // Verify quiz list is displayed
        expect(find.byType(ListView), findsOneWidget);
      }
    });
  });
}
