// lib/theme/feuerwehr_theme.dart

import 'package:flutter/material.dart';

class FFWColors {
  static const Color rot = Color(0xFFCC0000);
  static const Color rotDunkel = Color(0xFF990000);
  static const Color rotHell = Color(0xFFFF3333);
  static const Color weiss = Color(0xFFFFFFFF);
  static const Color dunkel = Color(0xFF1A1A1A);
  static const Color grauHell = Color(0xFFF5F5F5);
  static const Color grau = Color(0xFF9E9E9E);
  static const Color gueltig = Color(0xFF2E7D32);
  static const Color ungueltig = Color(0xFFB71C1C);
}

ThemeData feuerwehrTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: FFWColors.rot,
      primary: FFWColors.rot,
      onPrimary: FFWColors.weiss,
      surface: FFWColors.weiss,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: FFWColors.rot,
      foregroundColor: FFWColors.weiss,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: FFWColors.weiss,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FFWColors.rot,
        foregroundColor: FFWColors.weiss,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: FFWColors.rot, width: 2),
      ),
      labelStyle: const TextStyle(color: FFWColors.grau),
    ),
  );
}
