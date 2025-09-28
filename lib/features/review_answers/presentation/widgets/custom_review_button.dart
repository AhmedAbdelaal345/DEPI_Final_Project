// lib/features/review_answers/presentation/widgets/custom_review_button.dart
import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomReviewButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const CustomReviewButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? ColorApp.primaryButtonColor 
              : ColorApp.primaryButtonColor.withOpacity(0.3),
          foregroundColor: isEnabled 
              ? Colors.white 
              : Colors.white.withOpacity(0.5),
          elevation: isEnabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.judson(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: isEnabled 
                ? Colors.white 
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}