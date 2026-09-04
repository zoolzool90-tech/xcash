import 'package:flutter/material.dart';

class XCashTheme {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color carbonBlack = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: carbonBlack,
    primaryColor: primaryGold,
    cardColor: darkCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: carbonBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primaryGold,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
