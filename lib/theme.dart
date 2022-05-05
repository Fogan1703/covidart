import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color purple = Color(0xFF473F97);
  static const Color red = Color(0xFFFF4C58);
  static const Color blue = Color(0xFF4C79FF);
  static const Color lightBlue = Color(0xFF4CB5FF);
  static const Color yellow = Color(0xFFFFB259);
  static const Color green = Color(0xFF4CD97B);
  static const Color blueGray = Color(0xFF999FBF);

  static final ThemeData theme = ThemeData(
    primaryColor: purple,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: blue,
      unselectedItemColor: blueGray,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
