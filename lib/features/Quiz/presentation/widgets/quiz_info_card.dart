import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class QuizInfoCard extends StatelessWidget {
  const QuizInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isIconTop,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isIconTop;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(sx(context, 12));
    final labelStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 12),
      fontWeight: FontWeight.w600,
    );
    final valueStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, isIconTop ? 18 : 16),
      fontWeight: FontWeight.w700,
    );

    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: r),
      padding: EdgeInsets.symmetric(
        horizontal: sx(context, 16),
        vertical: sy(context, 14),
      ),
      child: isIconTop
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.bgDarkText, size: sx(context, 24)),
                SizedBox(height: sy(context, 6)),
                Text(title, style: labelStyle),
                SizedBox(height: sy(context, 2)),
                Text(value, style: valueStyle),
              ],
            )
          : Row(
              children: [
                Icon(icon, color: AppColors.bgDarkText, size: sx(context, 24)),
                SizedBox(width: sx(context, 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: labelStyle),
                    SizedBox(height: sy(context, 2)),
                    Text(value, style: valueStyle),
                  ],
                ),
              ],
            ),
    );
  }
}
