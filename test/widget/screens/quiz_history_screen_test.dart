import 'package:depi_final_project/features/home/presentation/Screens/quiz_history_screen.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/data/repositories/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import '../../test_utils/firebase_mocks.dart';
import 'package:depi_final_project/core/services/cache_service.dart';

class FakeCacheService implements CacheService {
  final Map<String, String> _storage = {};

  @override
  Future<void> saveString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _storage[key];
  }
  
  @override
  Future readJson(String key) {
    // TODO: implement readJson
    throw UnimplementedError();
  }
  
  @override
  Future<void> remove(String key) {
    // TODO: implement remove
    throw UnimplementedError();
  }
  
  @override
  Future<void> saveJson(String key, Object value) {
    // TODO: implement saveJson
    throw UnimplementedError();
  }

  // لو CacheService فيها methods تانية ومش abstract مش هتحتاج تكمل،
  // لو abstract وطلب منك تكمل override لميثودز تانية، اعملها بـ stubs فاضية.
}

void main() {
  setupFirebaseMocks();

  Widget createQuizHistoryScreen() {
    final historyRepository = HistoryRepository(cacheService: FakeCacheService());
    
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
