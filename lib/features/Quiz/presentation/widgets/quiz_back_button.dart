import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/widgets/app_constants.dart';

class QuizBackButton extends StatelessWidget {
  const QuizBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sy(context, 52),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.bgDarkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sx(context, 16)),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          'Back to Home',
          style: GoogleFonts.judson(
            color: AppColors.bgDarkText,
            fontWeight: FontWeight.w700,
            fontSize: sx(context, 18),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
