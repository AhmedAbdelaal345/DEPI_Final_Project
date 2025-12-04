import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  Widget createLoginScreen() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginScreen(),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders correctly with all key elements', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Verify email text field is present
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      
      // Verify password text field is present
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      
      // Verify login button is present
      expect(find.text('Login'), findsOneWidget);
      
      // Verify forgot password link is present
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('email field accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final emailField = find.byIcon(Icons.email_outlined);
      expect(emailField, findsOneWidget);

      // Find the TextField widget
      final textField = find.ancestor(
        of: emailField,
        matching: find.byType(TextFormField),
      );

      await tester.enterText(textField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('password field accepts text input and obscures text', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final passwordField = find.byIcon(Icons.lock_outline);
      expect(passwordField, findsOneWidget);

      // Find the TextField widget
      final textField = find.ancestor(
        of: passwordField,
        matching: find.byType(TextFormField),
      );

      await tester.enterText(textField, 'password123');
      await tester.pump();

      // Verify the TextFormField has obscureText enabled
      final textFormField = tester.widget<TextFormField>(textField);
      expect(textFormField.obscureText, isTrue);
    });

    testWidgets('shows validation error for empty email', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Tap login button without entering email
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Enter invalid email
      final emailField = find.ancestor(
        of: find.byIcon(Icons.email_outlined),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(emailField, 'invalid-email');
      
      // Enter valid password
      final passwordField = find.ancestor(
        of: find.byIcon(Icons.lock_outline),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(passwordField, 'password123');
      
      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows validation error for empty password', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Enter valid email
      final emailField = find.ancestor(
        of: find.byIcon(Icons.email_outlined),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(emailField, 'test@example.com');

      // Tap login button without entering password
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows validation error for short password', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Enter valid email
      final emailField = find.ancestor(
        of: find.byIcon(Icons.email_outlined),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(emailField, 'test@example.com');

      // Enter short password
      final passwordField = find.ancestor(
        of: find.byIcon(Icons.lock_outline),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(passwordField, '123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('forgot password link is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      final forgotPasswordLink = find.text('Forgot Password?');
      expect(forgotPasswordLink, findsOneWidget);

      // Verify it's wrapped in an InkWell (tappable)
      final inkWell = find.ancestor(
        of: forgotPasswordLink,
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);
    });

    testWidgets('create account link is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Verify "Don't have an account?" text is present
      expect(find.textContaining("Don't have an account?"), findsOneWidget);
      
      // Verify "Create new account" text is present
      expect(find.textContaining('Create new account'), findsOneWidget);
    });

    testWidgets('displays loading indicator when logging in', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pumpAndSettle();

      // Enter valid credentials
      final emailField = find.ancestor(
        of: find.byIcon(Icons.email_outlined),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.ancestor(
        of: find.byIcon(Icons.lock_outline),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(passwordField, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump(); // Don't settle, check loading state

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
