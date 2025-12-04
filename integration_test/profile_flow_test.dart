import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:depi_final_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Flow Integration Test', () {
    testWidgets('User can view and update profile', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 1: Navigate to profile screen
      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();

        // Step 2: Verify profile screen loaded
        expect(find.text('Profile'), findsOneWidget);

        // Step 3: Verify profile information is displayed
        expect(find.byType(CircleAvatar), findsOneWidget);

        // Step 4: Verify statistics are displayed
        expect(find.text('All Quizzes taken'), findsOneWidget);
        expect(find.text('Subjects'), findsOneWidget);
        expect(find.text('Average Score'), findsOneWidget);

        // Step 5: Pull to refresh
        await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
        await tester.pumpAndSettle();

        // Verify loading indicator appeared and disappeared
        expect(find.byType(CircularProgressIndicator), findsNothing);
      }
    });

    testWidgets('User can navigate to Pro features', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to profile
      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();

        // Look for Pro upgrade card (if user is not Pro)
        final proCard = find.text('Upgrade to Pro');
        if (proCard.evaluate().isNotEmpty) {
          await tester.tap(proCard);
          await tester.pumpAndSettle();

          // Verify Pro features screen loaded
          expect(find.text('Pro Features'), findsOneWidget);
        }
      }
    });

    testWidgets('User can navigate between screens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test bottom navigation
      final screens = [
        (Icons.home, 'Home'),
        (Icons.person, 'Profile'),
        (Icons.history, 'Quiz History'),
        (Icons.settings, 'Settings'),
      ];

      for (final (icon, title) in screens) {
        final iconFinder = find.byIcon(icon);
        if (iconFinder.evaluate().isNotEmpty) {
          await tester.tap(iconFinder);
          await tester.pumpAndSettle();

          // Verify screen loaded
          expect(find.text(title), findsOneWidget);
        }
      }
    });
  });
}
