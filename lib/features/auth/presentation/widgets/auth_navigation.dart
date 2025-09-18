import 'package:flutter/material.dart';

import '../../../../core/constants/color_app.dart';
import '../screens/login_screen.dart';

class AuthNavigation extends StatelessWidget {
  final String promptText;
  final String buttonText;
  final VoidCallback onNavPressed;
  const AuthNavigation({
    super.key,
    required this.promptText,
    required this.buttonText,
    required this.onNavPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onNavPressed,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: promptText,
              style: TextStyle(color: ColorApp.whiteColor),
            ),
            TextSpan(
              text: buttonText,
              style: TextStyle(
                color: ColorApp.splashTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
