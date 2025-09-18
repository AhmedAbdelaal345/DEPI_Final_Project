import 'package:flutter/material.dart';

// App Colors
class AppColors {
  // Tuned to match the screenshots
  static const bg = Color(0xFF000921); // Deep navy background
  static const teal = Color(0xFF4FB3B7); // Primary teal (buttons/nav)
  static const tealHighlight = Color(0xFF84D9D7); // Active icon circle
  static const card = Color(0xFFD9D9D9); // Light grey cards/fields
  static const hint = Color(0xFF000920); // Placeholder/hint
  static const bgDarkText = Color(0xFF0B1B2A); // Dark text on light
}

// Utility scaling for 390 x 844 design (iPhone 13/14)
double sx(BuildContext context, double x) => x * MediaQuery.of(context).size.width / 390;
double sy(BuildContext context, double y) => y * MediaQuery.of(context).size.height / 844;
