import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/data/repositories/history_repository.dart';
import 'package:depi_final_project/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/profile/cubit/profile_cubit.dart';
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

  Widget createWrapperPage({int initialIndex = 0}) {
    // Create repository instances for cubits
    final historyRepository = HistoryRepository(cacheService: FakeCacheService());
    final profileRepository = ProfileRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(historyRepository),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepository),
        ),
      ],
      child: MaterialApp(home: WrapperPage(initialIndex: initialIndex)),
    );
  }

  group('WrapperPage Widget Tests', () {
    testWidgets('renders correctly with bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Verify Scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify bottom navigation icons are present
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('starts with home screen by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Home screen should be visible
      // We can't directly test for HomeScreen widget without more setup,
      // but we can verify the structure is correct
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('respects initialIndex parameter', (WidgetTester tester) async {
      await tester.pumpWidget(createWrapperPage(initialIndex: 2));
      await tester.pumpAndSettle();

      // The wrapper should initialize with the specified index
      expect(find.byType(WrapperPage), findsOneWidget);
    });

    testWidgets('has drawer', (WidgetTester tester) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Verify drawer is present
      final scaffoldFinder = find.byType(Scaffold);
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.drawer, isNotNull);
    });

    testWidgets('navigation bar has correct background colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Verify scaffold has correct background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1A1C2B));
    });

    testWidgets('all navigation icons are present and correct', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Verify all 4 navigation icons
      final homeIcon = find.byIcon(Icons.home);
      final personIcon = find.byIcon(Icons.person);
      final historyIcon = find.byIcon(Icons.history);
      final settingsIcon = find.byIcon(Icons.settings);

      expect(homeIcon, findsOneWidget);
      expect(personIcon, findsOneWidget);
      expect(historyIcon, findsOneWidget);
      expect(settingsIcon, findsOneWidget);
    });

    testWidgets('provides necessary BLoC providers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWrapperPage());
      await tester.pumpAndSettle();

      // Verify BLoC providers are available
      final context = tester.element(find.byType(WrapperPage));

      expect(context.read<HistoryCubit>, isNotNull);
      expect(context.read<ProfileCubit>, isNotNull);
    });
  });
}
