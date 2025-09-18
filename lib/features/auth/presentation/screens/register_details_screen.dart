import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_details_cubit.dart';
import '../cubit/register_details_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation.dart';
import '../widgets/register_form.dart';
import '../widgets/social_login_section.dart';

class RegisterDetailsScreen extends StatelessWidget {
  const RegisterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegisterDetailsCubit(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundColor,
        body: SafeArea(
          child: BlocListener<RegisterDetailsCubit, RegisterDetailsState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Successful!')),
                );
                // After successful registration, navigate to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (state.status == RegisterStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.generalError ?? 'An error occurred'),
                  ),
                );
              }
            },

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AuthHeader(
                      title: 'Register',
                      subtitle: 'Welcome  ! please enter your details',
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    RegisterForm(),
                    SizedBox(height: screenHeight * 0.05),
                    SocialLoginSection(text: 'OR Register with'),

                    SizedBox(height: screenHeight * 0.04),

                    AuthNavigation(
                      promptText: 'Already have an account? ',
                      buttonText: 'Login',
                      onNavPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
