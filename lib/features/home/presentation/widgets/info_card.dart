import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

class InfoCard extends StatelessWidget {
  const InfoCard._({required this.child});

  factory InfoCard.iconTop({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return InfoCard._(
      child: _IconTopCardContent(icon: icon, title: title, value: value),
    );
  }

  factory InfoCard.inline({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return InfoCard._(
      child: _InlineCardContent(icon: icon, title: title, value: value),
    );
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(sx(context, 12));
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: r),
      padding: EdgeInsets.symmetric(
        horizontal: sx(context, 16),
        vertical: sy(context, 14),
      ),
      child: child,
    );
  }
}

class _IconTopCardContent extends StatelessWidget {
  const _IconTopCardContent({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 12),
      fontWeight: FontWeight.w600,
    );
    final valueStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 18),
      fontWeight: FontWeight.w700,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.bgDarkText, size: sx(context, 24)),
        SizedBox(height: sy(context, 6)),
        Text(title, style: labelStyle),
        SizedBox(height: sy(context, 2)),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _InlineCardContent extends StatelessWidget {
  const _InlineCardContent({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 12),
      fontWeight: FontWeight.w600,
    );
    final valueStyle = GoogleFonts.poppins(
      color: AppColors.bgDarkText,
      fontSize: sx(context, 16),
      fontWeight: FontWeight.w700,
    );

    return Row(
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
    );
  }
}
