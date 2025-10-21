import 'package:depi_final_project/features/Teacher/screens/homeTeacher.dart';
import 'package:depi_final_project/features/Teacher/screens/home_teacher.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/login_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/cubit/register_details_cubit.dart';
import 'package:depi_final_project/features/auth/presentation/widgets/social_icon_button.dart';
import 'package:depi_final_project/features/home/presentation/Screens/wrapper_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          iconPath: AppConstants.googleLogo,
          onPressed: () async {
            try {
              final loginCubit = BlocProvider.of<LoginCubit>(context);
              final registerCubit = context.read<RegisterDetailsCubit>();
              
              // Sign in with Google
              final user = await loginCubit.signInWithGoogle();
              
              if (user != null) {
                // Check if user is a teacher
                final isTeacher = await loginCubit.isTeacher();
                
                // Register user details
                await registerCubit.register(
                  fullName: user.additionalUserInfo?.profile?['name'] ?? 
                           user.user?.displayName ?? 
                           'User',
                  email: user.user?.email ?? '',
                  password: "GoogleSignIn",
                  confirmPassword: "GoogleSignIn",
                  isTeacher: isTeacher,
                );
                
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isTeacher 
                          ? Hometeacher() 
                          : WrapperPage(),
                    ),
                  );
                }
              }
            } catch (e) {
              // Show error to user
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sign in failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        SizedBox(width: screenWidth * 0.04),
        SocialIconButton(iconPath: AppConstants.facebookLogo, onPressed: () {}),
        SizedBox(width: screenWidth * 0.04),
        SocialIconButton(iconPath: AppConstants.appleLogo, onPressed: () {}),
      ],
    );
  }
}