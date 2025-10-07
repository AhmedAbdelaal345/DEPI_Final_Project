import 'package:flutter/material.dart';

/// App Theme Constants
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Background Colors
  static const Color backgroundDark = Color(0xFF000921);
  static const Color backgroundLight = Color(0xFF1A1C2B);
  static const Color cardBackground = Color(0xFF2C2F48);

  // Primary Colors
  static const Color primaryTeal = Color(0xFF4FB3B7);
  static const Color primaryTealLight = Color(0xFF5AC7C7);
  static const Color tealHighlight = Color(0xFF84D9D7);

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0B0);
  static const Color textDark = Color(0xFF0B1B2A);
  static const Color hintText = Color(0xFF000920);

  // Accent Colors
  static const Color cardGrey = Color(0xFFD9D9D9);
  static const Color errorRed = Colors.red;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}

/// Utility scaling functions for responsive design (390 x 844 design base)
class AppResponsive {
  // Private constructor
  AppResponsive._();

  static double scaleWidth(BuildContext context, double width) {
    return width * MediaQuery.of(context).size.width / 390;
  }

  static double scaleHeight(BuildContext context, double height) {
    return height * MediaQuery.of(context).size.height / 844;
  }
}

