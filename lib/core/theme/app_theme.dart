import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium dark palette — no bright colors
  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF141414);
  static const Color _surfaceHigh = Color(0xFF1C1C1E);
  static const Color _border = Color(0xFF2C2C2E);
  static const Color _textPrimary = Color(0xFFF5F5F7);
  static const Color _textSecondary = Color(0xFF8E8E93);
  static const Color _accent = Color(0xFFD4D4D8); // silver

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _accent,
      onPrimary: _bg,
      secondary: const Color(0xFF48484A),
      tertiary: const Color(0xFF636366),
      surface: _surface,
      onSurface: _textPrimary,
      onSurfaceVariant: _textSecondary,
      outline: _border,
      outlineVariant: _border,
      surfaceContainerHighest: _surfaceHigh,
      error: const Color(0xFFFF453A),
    ),
    scaffoldBackgroundColor: _bg,
    textTheme: _buildTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: _bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
        letterSpacing: -0.3,
      ),
      iconTheme: const IconThemeData(color: _textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _accent, width: 1),
      ),
      hintStyle: GoogleFonts.inter(color: _textSecondary, fontSize: 15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _textPrimary,
        foregroundColor: _bg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _textPrimary,
        side: BorderSide(color: _border),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _surfaceHigh,
      selectedColor: _textPrimary.withOpacity(0.15),
      side: BorderSide(color: _border),
      labelStyle: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(color: _border, thickness: 0.5),
    cardTheme: CardThemeData(
      color: _surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _border),
      ),
    ),
  );

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, color: _textPrimary),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w600, letterSpacing: -0.5, color: _textPrimary),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: _textPrimary),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: _textPrimary),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: _textPrimary),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: _textPrimary),
      titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: _textPrimary),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.1, color: _textPrimary),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0, color: _textPrimary),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: _textPrimary),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: _textSecondary),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: _textSecondary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: _textPrimary),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: _textPrimary),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4, color: _textSecondary),
    );
  }
}
