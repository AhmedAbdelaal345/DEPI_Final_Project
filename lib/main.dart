import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/login_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/register_details_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/manager/history_cubit/history_cubit.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/result_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/screens/quiz_page.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/features/review_answers/presentation/cubit/review_answers_cubit.dart';
import 'package:depi_final_project/features/review_answers/presentation/screens/review_details_screen.dart'
    show ReviewDetailsScreen;
import 'package:depi_final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/home/presentation/cubit/locale_cubit.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterDetailsCubit()),
        BlocProvider<QuizCubit>(create: (context) => QuizCubit()),
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
            home: SplashScreen(),
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
