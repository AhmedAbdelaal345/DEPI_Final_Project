import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/Onboarding/screens/onboarding_screen.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToLogin) {
            // Check if user is already logged in
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              // User is logged in, go to home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WrapperPage()),
              );
            } else {
              // User not logged in, go to onboarding
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );
            }
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
                const SizedBox(height: 22),
                Text(
                  'QUIZLY',
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
