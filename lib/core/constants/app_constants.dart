import 'package:flutter/material.dart';

abstract class AppConstants {
  // ==================== Regex Patterns ====================
  static final String emailRegExp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // ==================== Asset Paths ====================
  static final String brainLogo = 'assets/images/brain_logo.png';
  static final String googleLogo = 'assets/images/google_logo.png';
  static final String facebookLogo = 'assets/images/facebook_logo.png';
  static final String appleLogo = 'assets/images/apple_logo.png';
  
  // ==================== Firestore Field Names ====================
  static final String text = 'question';
  static final String options = 'option';
  static final String correctAnswer = 'answer';
  static final String questionsCollection = 'questions';
  static final String question = 'question';
  static final String quizzesCollection = 'Quizzes';
  static final String quizzessmall = 'quizzes';
  static final String teacherCollection = 'teacher';
  static final String studentCollection = 'Student';
  static final String createdAt = 'createdAt';
  static final String score = 'score';
  static final String total = 'total';
  static final String status = 'status';
  static final String submittedAt = 'submittedAt';
  static final String details = 'details';
  static final String title = 'title';
  static final String id = 'id';
  static final String uId = "uid";
  static final String quizId = "quizid";
  static final String teacherId = "teacherId";
  static final String accuracy = 'accuracy';
  static final String answer = 'answer';
  static final String subject = 'subject';
  static final String duration = "duration";
  static final String quesCount = "question_count";
  static final String name = "name";
  static final String teacherName = "teacherName";
  static final String studentAnswer = "studentAnswer";
  static final String chatRoom = 'chat_rooms';
  static final String messagesCollection = 'messages';
}

// ==================== App Colors ====================
abstract class AppColors {
  // Primary Colors
  static const Color primaryBackground = Color(0xFF000920);
  static const Color secondaryBackground = Color(0xFF061438);
  static const Color cardBackground = Color(0xFF1A1C2B);
  
  // Accent Colors
  static const Color primaryTeal = Color(0xFF4FB3B7);
  static const Color secondaryTeal = Color(0xFF62DDE1);
  static const Color tealHighlight = Color(0xFF84D9D7);
  static const Color lightTeal = Color(0xFF1ABC9C);
  static const Color tealWithOpacity = Color(0x1877F21C);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color white54 = Colors.white54;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF455A64);
  static const Color lightGrey = Color(0xFFD9D9D9);
  
  // Text Colors
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Colors.white54;
  static const Color hintText = Color(0xFF000920);
  
  // Status Colors
  static const Color error = Colors.red;
  static const Color success = Color(0xFF4FB3B7);

  // Aliases for compatibility
  static const Color bg = primaryBackground;
  static const Color teal = primaryTeal;
  static const Color card = Color(0xFFD9D9D9);
  static const Color hint = Color(0xFF000920);
  static const Color bgDarkText = Color(0xFF0B1B2A);
  static const Color red = error;
}

// ==================== App Spacing ====================
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ==================== App Border Radius ====================
abstract class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 15.0;
  static const double lg = 20.0;
  static const double xl = 30.0;
  
  static BorderRadius smallBorderRadius = BorderRadius.circular(sm);
  static BorderRadius mediumBorderRadius = BorderRadius.circular(md);
  static BorderRadius largeBorderRadius = BorderRadius.circular(lg);
  static BorderRadius extraLargeBorderRadius = BorderRadius.circular(xl);
}

// ==================== App Font Sizes ====================
abstract class AppFontSizes {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
}

// ==================== App Dimensions ====================
abstract class AppDimensions {
  static const double borderWidth = 2.0;
  static const double iconSize = 24.0;
  static const double buttonHeight = 60.0;
}
