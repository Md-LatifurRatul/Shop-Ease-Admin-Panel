import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    fontFamilyFallback: ['Noto Sans', 'Noto Color Emoji'],
    useMaterial3: true,
    colorSchemeSeed: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFFF4F6F8),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade900),
    ),
  );
}
