import 'package:depi_final_project/features/home/presentation/Screens/quiz_history_screen.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/data/repositories/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import '../../test_utils/firebase_mocks.dart';

void main() {
  setupFirebaseMocks();

  Widget createQuizHistoryScreen() {
    final historyRepository = HistoryRepository();
    
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => HistoryCubit(historyRepository),
        child: const QuizHistoryScreen(),
      ),
    );
  }

  group('QuizHistoryScreen Widget Tests', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createQuizHistoryScreen());
      await tester.pump();

      // Verify screen is rendered
      expect(find.byType(QuizHistoryScreen), findsOneWidget);
    });

    testWidgets('displays UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createQuizHistoryScreen());
      await tester.pump();

      // Verify basic UI structure is present
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has app bar', (WidgetTester tester) async {
      await tester.pumpWidget(createQuizHistoryScreen());
      await tester.pump();

      // Verify AppBar is present
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
