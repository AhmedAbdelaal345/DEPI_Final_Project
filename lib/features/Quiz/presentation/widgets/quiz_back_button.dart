import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class QuizBackButton extends StatelessWidget {
  const QuizBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          l10n.backToHome,
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
