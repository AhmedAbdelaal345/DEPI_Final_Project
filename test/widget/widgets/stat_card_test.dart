import 'package:depi_final_project/features/profile/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createStatCard({
    required String icon,
    required String label,
    required String value,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: StatCard(
          icon: icon,
          label: label,
          value: value,
        ),
      ),
    );
  }

  group('StatCard Widget Tests', () {
    testWidgets('renders with correct label and value', (WidgetTester tester) async {
      await tester.pumpWidget(
        createStatCard(
          icon: 'test-icon',
          label: 'Total Quizzes',
          value: '42',
        ),
      );

      expect(find.text('Total Quizzes'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('displays icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        createStatCard(
          icon: 'test-icon',
          label: 'Score',
          value: '95%',
        ),
      );

      // Verify icon widget is present
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('handles long values correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createStatCard(
          icon: 'test-icon',
          label: 'Very Long Label Name',
          value: '999999',
        ),
      );

      expect(find.text('Very Long Label Name'), findsOneWidget);
      expect(find.text('999999'), findsOneWidget);
    });
  });
}
