import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/color_app.dart';

class AuthHeader  extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader ({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.irishGrover(
            fontSize: screenWidth * 0.1,
            fontWeight: FontWeight.w400,
            color: ColorApp.whiteColor,
          ),
        ),
        SizedBox(height: screenHeight * 0.035),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: screenWidth * 0.033,
            fontWeight: FontWeight.w400,
            color: ColorApp.whiteColor,
          ),
        ),
      ],
    );
  }
}
