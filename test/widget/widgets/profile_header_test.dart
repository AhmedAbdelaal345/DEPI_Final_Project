import 'package:depi_final_project/features/profile/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileHeader Widget Tests', () {
    testWidgets('displays user information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              userName: 'John Doe',
              userEmail: 'john.doe@example.com',
              profileImageUrl: 'assets/images/brain_logo.png',
              isPro: false,
            ),
          ),
        ),
      );

      // Verify user name is displayed
      expect(find.text('John Doe'), findsOneWidget);
      
      // Verify email is displayed
      expect(find.text('john.doe@example.com'), findsOneWidget);
      
      // Verify profile image is present
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('displays PRO badge when isPro is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              userName: 'Jane Pro',
              userEmail: 'jane@example.com',
              profileImageUrl: 'assets/images/brain_logo.png',
              isPro: true,
            ),
          ),
        ),
      );

      // Use pump() instead of pumpAndSettle() to avoid infinite animation timeout
      await tester.pump(const Duration(milliseconds: 100));

      // Verify PRO badge is displayed
      expect(find.text('PRO'), findsOneWidget);
      
      // Verify premium icon is present
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });

    testWidgets('does not display PRO badge when isPro is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              userName: 'Regular User',
              userEmail: 'regular@example.com',
              profileImageUrl: 'assets/images/brain_logo.png',
              isPro: false,
            ),
          ),
        ),
      );

      // Use pump() instead of pumpAndSettle()
      await tester.pump(const Duration(milliseconds: 100));

      // Verify PRO badge is not displayed
      expect(find.text('PRO'), findsNothing);
      expect(find.byIcon(Icons.workspace_premium), findsNothing);
    });

    testWidgets('has proper widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              userName: 'Test User',
              userEmail: 'test@example.com',
              profileImageUrl: 'assets/images/brain_logo.png',
              isPro: true,
            ),
          ),
        ),
      );

      // Use pump() to avoid animation timeout
      await tester.pump(const Duration(milliseconds: 100));

      // Verify Stack widget for layered design
      expect(find.byType(Stack), findsWidgets);
      
      // Verify Column for vertical layout
      expect(find.byType(Column), findsWidgets);
      
      // Verify Container widgets for styling
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('animation controller is properly initialized', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              userName: 'Animated User',
              userEmail: 'animated@example.com',
              profileImageUrl: 'assets/images/brain_logo.png',
              isPro: true,
            ),
          ),
        ),
      );

      // Initial pump
      await tester.pump();
      
      // Advance time to test animation (but don't wait for settle)
      await tester.pump(const Duration(milliseconds: 500));
      
      // Verify widget is still present after animation
      expect(find.byType(ProfileHeader), findsOneWidget);
    });
  });
}
