import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

// App Colors - Using the new AppTheme constants
class AppColors {
  // Background colors
  static const bg = AppTheme.backgroundDark;
  static const bgLight = AppTheme.backgroundLight;

  // Primary colors
  static const teal = AppTheme.primaryTeal;
  static const tealHighlight = AppTheme.tealHighlight;

  // Card colors
  static const card = AppTheme.cardGrey;

  // Text colors
  static const hint = AppTheme.hintText;
  static const bgDarkText = AppTheme.textDark;
  static const white = AppTheme.textWhite;
  static const red = AppTheme.errorRed;
}

// Utility scaling for 390 x 844 design (iPhone 13/14)
double sx(BuildContext context, double x) => AppResponsive.scaleWidth(context, x);
double sy(BuildContext context, double y) => AppResponsive.scaleHeight(context, y);
