import 'package:depi_final_project/features/auth/presentation/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/color_app.dart';

class SocialLoginSection extends StatelessWidget {
  final String text;
  const SocialLoginSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: ColorApp.whiteColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.003,
              ),
              child: Text(
                text,
                style: GoogleFonts.irishGrover(
                  color: ColorApp.whiteColor,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: ColorApp.whiteColor),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.05),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              iconPath: AppConstants.googleLogo,
              onPressed: () {},
            ),
            SizedBox(width: screenWidth * 0.04),
            SocialIconButton(
              iconPath: AppConstants.facebookLogo,
              onPressed: () {},
            ),
            SizedBox(width: screenWidth * 0.04),
            SocialIconButton(
              iconPath: AppConstants.appleLogo,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
