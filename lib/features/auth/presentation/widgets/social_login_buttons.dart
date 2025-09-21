import 'package:depi_final_project/features/auth/presentation/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
