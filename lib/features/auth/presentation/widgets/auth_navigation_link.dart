import 'package:flutter/material.dart';
import '../../../../core/constants/color_app.dart';

class AuthNavigationLink extends StatelessWidget {
  final String baseText;
  final String clickableText;
  final VoidCallback onPressed;
  const AuthNavigationLink({
    super.key,
    required this.baseText,
    required this.clickableText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressed,
      child: RichText(
        text:  TextSpan(
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: baseText,
              style: TextStyle(
                color: ColorApp.whiteColor,
              ),
            ),
            TextSpan(
              text: clickableText,
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
