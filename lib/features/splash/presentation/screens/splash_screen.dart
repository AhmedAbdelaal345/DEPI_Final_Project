import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/Onboarding/screens/onboarding_screen.dart';
import 'package:depi_final_project/features/Teacher/screens/wrapper_teacher_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/splash_cubit.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnboarding) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          } else if (state is SplashNavigateToStudent) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WrapperPage()),
            );
          } else if (state is SplashNavigateToTeacher) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WrapperTeacherPage()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: ColorApp.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.brainLogo,
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                ),
                SizedBox(height: 22),
                Text(
                  l10n.appName,
                  style: GoogleFonts.irishGrover(
                    fontWeight: FontWeight.w400,
                    fontSize: 64,
                    color: ColorApp.splashTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
