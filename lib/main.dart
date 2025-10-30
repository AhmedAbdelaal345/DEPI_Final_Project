import 'dart:developer';
import 'dart:ui';
import 'package:depi_final_project/features/Onboarding/widgets/last_page_buttons.dart';
import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/login_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/register_details_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/features/auth/presentation/screens/update_page.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/result_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/screens/quiz_page.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/screens/review_details_screen.dart'
    show ReviewDetailsScreen;
import 'package:depi_final_project/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/features/home/cubit/locale_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar settings
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  // Error widget for uncaught exceptions
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Text(
          '⚠️ Something went wrong!\n${details.exception}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.white, fontSize: 16),
        ),
      ),
    );
  };


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late FirebaseAnalytics analytics;
  late FirebaseAnalyticsObserver observer;
   @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }
  Future<bool> remoteConfig() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      log(packageInfo.version);
      String appVersion = packageInfo.version;

      FirebaseRemoteConfig remote = FirebaseRemoteConfig.instance;
      await remote.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 60),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remote.fetchAndActivate();
      String remoteVersion = remote.getString('AppVersion');

      return remoteVersion.compareTo(appVersion) == 1;
    } catch (e) {
      log("Remote config error: $e");
      return false; // Continue with app if remote config fails
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterDetailsCubit()),
        BlocProvider<QuizCubit>(create: (context) => QuizCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()..userHaveLogin()),
        BlocProvider<ReviewAnswersCubit>(
          create: (context) => ReviewAnswersCubit(),
        ),
        BlocProvider<CreateQuizCubit>(create: (context) => CreateQuizCubit()),
        BlocProvider(create: (context) => ResultCubit()),
        BlocProvider(create: (context) => HistoryCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: FutureBuilder(
              future: remoteConfig(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(color: AppColors.white),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  log("FutureBuilder error: ${snapshot.error}");
                }
                if (snapshot.data == true) {
                  return const UpdatePage();
                }
                return BlocBuilder<AuthCubit, Widget>(
                  builder: (context, state) {
                    return state;
                  },
                );
              },
            ),
            theme: ThemeData(
              fontFamily: "Judson",
              useMaterial3: false,
              scaffoldBackgroundColor: AppColors.bg,
              colorScheme: const ColorScheme.dark(
                primary: AppColors.teal,
                background: AppColors.bg,
                surface: AppColors.bg,
              ),
              textTheme: TextTheme(
                titleLarge: GoogleFonts.cinzelDecorative(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                bodyMedium: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.35,
                ),
                labelLarge: GoogleFonts.poppins(
                  color: AppColors.bgDarkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            routes: {
              WrapperPage.id: (context) => WrapperPage(),
              SelectUserPage.id: (context) => SelectUserPage(),
              QuizPage.id: (context) => QuizPage(),
              ResultPage.id: (context) => ResultPage(),
              ReviewDetailsScreen.id:
                  (context) => ReviewDetailsScreen(fetchWrongAnswers: true),
              LoginScreen.id: (context) => LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
