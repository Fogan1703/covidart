import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = greyDarker;

  static const Color redDarker = Color(0xFFFF464F);
  static const Color red = Color(0xFFFF575F);
  static const Color redLighter = Color(0xFFFFE5E7);

  static const Color orangeDarker = Color(0xFFFF8A34);
  static const Color orange = Color(0xFFFF974A);
  static const Color orangeLighter = Color(0xFFFFEFE3);

  static const Color yellowDarker = Color(0xFFFFBC25);
  static const Color yellow = Color(0xFFFFC542);
  static const Color yellowLighter = Color(0xFFFEF3D9);

  static const Color greenDarker = Color(0xFF00BFA6);
  static const Color green = Color(0xFF3DD598);
  static const Color greenLighter = Color(0xFFD4F5E9);

  static const Color blueDarker = Color(0xFF2196F3);
  static const Color blue = Color(0xFF03A9F4);
  static const Color blueLighter = Color(0xFFE3EEFF);

  static const Color purpleDarker = Color(0xFF6952DC);
  static const Color purple = Color(0xFF755FE2);
  static const Color purpleLighter = Color(0xFFEDEAFD);

  static const Color greyDarker = Color(0xFF263238);
  static const Color grey = Color(0xFF899A96);
  static const Color greyLighter = Color(0xFFE4E9F3);

  static final ThemeData theme = ThemeData(
    primaryColor: primary,
  );
}
