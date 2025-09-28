import 'package:depi_final_project/features/Quiz/presentation/Screens/quiz_details_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/home_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:depi_final_project/features/questions/presentation/cubit/quiz_cubit.dart';
import 'package:depi_final_project/features/questions/presentation/screens/quiz_page.dart';
import 'package:depi_final_project/features/questions/presentation/screens/result_page.dart';
import 'package:depi_final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/splash/presentation/screens/splash_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
        QuizPage.id: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) => QuizCubit(),
      child: QuizPage(quizId: args),
    );
  },
        BeforeQuizScreen.id: (_) =>  BeforeQuizScreen(),
        WrapperPage.id: (_) => const WrapperPage(),
        ResultPage.id: (_) => const ResultPage(quizResult: null),
      },
      home: SplashScreen(),
    );
  }
}
