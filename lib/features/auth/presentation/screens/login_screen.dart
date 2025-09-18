import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:depi_final_project/features/auth/presentation/screens/register_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: ColorApp.backgroundColor,
        body: SafeArea(
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful!')),
                );
              } else if (state.status == LoginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.generalError ?? 'An error occurred'),
                  ),
                );
              }
            },
            child:  Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.065,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AuthHeader(
                          title: 'Login',
                          subtitle:
                              'Welcome back ! please enter your details',
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        LoginForm(),
                        SizedBox(height: screenHeight * 0.05),
                        SocialLoginSection(text:'OR Login with'),

                        SizedBox(height: screenHeight * 0.04),
                        AuthNavigation(
                          promptText: 'Don’t have an account? ',
                          buttonText: 'Create a new account',
                          onNavPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                const RegisterDetailsScreen(),
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