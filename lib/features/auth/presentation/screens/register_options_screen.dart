import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/register_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../widgets/custom_auth_button.dart';

class RegisterOptionsScreen extends StatelessWidget {
  const RegisterOptionsScreen({super.key});

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Register',
                  style: GoogleFonts.irishGrover(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: ColorApp.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Please choice type of your account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorApp.whiteColor,
                ),
              ),
              const SizedBox(height: 177),
              CustomAuthButton(
                text: 'as a student',
                onPressed: () {
                  _navigateToDetails(context);
                },
              ),
              const SizedBox(height: 34),
              CustomAuthButton(
                text: 'as a teacher',
                onPressed: () {
                  _navigateToDetails(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
