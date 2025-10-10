// import 'package:flutter/material.dart';

// class AppTheme {
//   // 🔹 هنا الكنترولر اللي هنستخدمه في أي مكان نغير الثيم
//   


//   // 🔹 ثيم الفاتح
//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primarySwatch: Colors.blue,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.blue,
//       foregroundColor: Colors.white,
//     ),
//   );

//   // 🔹 ثيم الغامق
//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primarySwatch: Colors.deepPurple,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.black,
//       foregroundColor: Colors.white,
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'color_app.dart';

class AppTheme {
  static ValueNotifier<ThemeMode> themeNotifier =ValueNotifier(ThemeMode.light);
  
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorApp.whiteColor,
    primaryColor: ColorApp.primaryButtonColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorApp.primaryButtonColor,
      foregroundColor: ColorApp.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorApp.textFieldBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ColorApp.successSnakBar,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorApp.backgroundColor,
    primaryColor: ColorApp.primaryButtonColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorApp.greyColor,
      foregroundColor: ColorApp.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorApp.greyColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ColorApp.successSnakBar,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}

