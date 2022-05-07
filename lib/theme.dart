import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color purpleLight = Color(0xFF9059ff);
  static const Color purple = Color(0xFF473F97);
  static const Color purpleDark = Color(0xFF2A255A);
  static const Color red = Color(0xFFFF4C58);
  static const Color blue = Color(0xFF4C79FF);
  static const Color lightBlue = Color(0xFF4CB5FF);
  static const Color yellow = Color(0xFFFFB259);
  static const Color green = Color(0xFF4CD97B);
  static const Color blueGray = Color(0xFF999FBF);

  static final ScrollBehavior scrollBehavior = AppScrollBehavior();

  static const _textTheme = TextTheme(
    headline5: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 18,
    ),
    subtitle2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
  );

  static final ThemeData theme = ThemeData(
    primaryColor: purple,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: blue,
      unselectedItemColor: blueGray,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: _textTheme,
    tabBarTheme: TabBarTheme(
      labelStyle: _textTheme.subtitle2,
      unselectedLabelStyle: _textTheme.subtitle2,
      labelColor: purpleDark,
      unselectedLabelColor: Colors.white,
      indicator: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
    ),
  );
}

class AppScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
