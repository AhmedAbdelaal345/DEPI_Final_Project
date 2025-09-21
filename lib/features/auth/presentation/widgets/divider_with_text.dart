import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/color_app.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const Expanded(
          child: Divider(color: ColorApp.whiteColor),
        ),
        Text(
          text,
          style: GoogleFonts.irishGrover(
            color: ColorApp.whiteColor,
            fontSize: screenWidth * 0.035,
          ),
        ),
        const Expanded(
          child: Divider(color: ColorApp.whiteColor),
        ),
      ],
    );
  }
}
