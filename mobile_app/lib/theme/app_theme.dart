import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pastel Palette
  static const Color background = Color(0xFFF0F4F8); // Very light blue-grey
  static const Color surface = Color(0xFFE2E8F0); // Slate 200 (Clay Base)

  static const Color primary = Color(
    0xFF8B5CF6,
  ); // Violet 500 (remains for contrast)
  static const Color secondary = Color(
    0xFF10B981,
  ); // Emerald 500 (remains for contrast)
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500

  // Clay Colors
  static const Color clayBase = Color(0xFFEef2f5); // Soft white-ish
  static const Color clayShadowDark = Color(0xFFA6ABBD);
  static const Color clayShadowLight = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.nunito(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
            headlineMedium: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            bodyLarge: GoogleFonts.nunito(
              fontSize: 16,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodySmall: GoogleFonts.nunito(
              fontSize: 14,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
      // We'll use custom buttons mostly, but default override just in case
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: primary.withValues(alpha:0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
