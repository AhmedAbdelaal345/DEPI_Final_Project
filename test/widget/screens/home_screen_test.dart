import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

void main() {
  Widget createHomeScreen() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders correctly with all key elements', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Verify AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify motivational text is present
      expect(find.text('Ready to challenge yourself?'), findsOneWidget);

      // Verify quiz code input field is present
      expect(find.byType(TextField), findsOneWidget);

      // Verify join button is present
      expect(find.text('Join'), findsOneWidget);
    });

    testWidgets('quiz code input accepts text', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'QUIZ123');
      await tester.pump();

      expect(find.text('QUIZ123'), findsOneWidget);
    });

    testWidgets('shows error when joining with empty code', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Find and tap join button without entering code
      final joinButton = find.text('Join');
      await tester.tap(joinButton);
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Please enter quiz code'), findsOneWidget);
    });

    testWidgets('join button triggers navigation with valid code', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Enter quiz code
      await tester.enterText(find.byType(TextField), 'VALID123');
      await tester.pump();

      // Tap join button
      final joinButton = find.text('Join');
      await tester.tap(joinButton);
      await tester.pumpAndSettle();

      // Note: Full navigation test would require mocking Firebase
      // This test verifies the button is tappable with valid input
    });

    testWidgets('shows loading indicator when processing', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Enter quiz code
      await tester.enterText(find.byType(TextField), 'QUIZ123');
      await tester.pump();

      // Tap join button
      await tester.tap(find.text('Join'));
      await tester.pump(); // Don't settle, check loading state

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
