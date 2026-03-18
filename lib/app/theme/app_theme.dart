import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData light() => _base(brightness: Brightness.light);
  static ThemeData dark() => _base(brightness: Brightness.dark);

  static ThemeData _base({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: isDark ? AppColors.cardDark : AppColors.cardLight,
    );

    final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final useGoogleFonts = GoogleFonts.config.allowRuntimeFetching;
    final bodyTheme = useGoogleFonts
        ? GoogleFonts.instrumentSansTextTheme(baseTextTheme)
        : baseTextTheme;

    TextStyle _heading(double size, FontWeight weight) {
      final base = useGoogleFonts
          ? GoogleFonts.bricolageGrotesque()
          : (baseTextTheme.headlineMedium ?? const TextStyle());
      return base.copyWith(
        fontSize: size,
        fontWeight: weight,
        color: isDark ? Colors.white : AppColors.textPrimaryLight,
      );
    }

    final textTheme = bodyTheme.copyWith(
      displayLarge: _heading(32, FontWeight.w800),
      displayMedium: _heading(26, FontWeight.w800),
      headlineSmall: _heading(20, FontWeight.w700),
      titleLarge: bodyTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : AppColors.textPrimaryLight,
      ),
      titleMedium: bodyTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
      ),
      bodyLarge: bodyTheme.bodyLarge?.copyWith(
        color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
      ),
      bodyMedium: bodyTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      fontFamily: useGoogleFonts ? GoogleFonts.instrumentSans().fontFamily : null,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _heading(20, FontWeight.w700),
      ),
      cardColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        hintStyle: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? AppColors.border : AppColors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? AppColors.border : AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: _heading(16, FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isDark ? Colors.white24 : AppColors.primary),
          foregroundColor: isDark ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: _heading(16, FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: _heading(16, FontWeight.w700),
        ),
      ),
      dividerColor: isDark ? AppColors.border : AppColors.borderStrong,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
