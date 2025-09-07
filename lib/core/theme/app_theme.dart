import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A collection of application wide colours used throughout the UI. Keeping the
/// palette in one place makes it trivial to adjust styling later on without
/// hunting through dozens of widgets.
class AppColors {
  /// Palette derived from https://coolors.co/palette/f6bd60-f7ede2-f5cac3-84a59d-f28482

  /// The overall app background – a warm beige (#F7EDE2).
  static const Color background = Color(0xFFF7EDE2);

  /// Colour used for cards and form containers. A very light off‑white to
  /// contrast gently with the background. We keep the existing off‑white
  /// (#FBF8F4) which harmonises well with the palette.
  static const Color card = Color(0xFFFBF8F4);

  /// Primary accent colour for buttons and active elements (salmon #F28482).
  static const Color primary = Color(0xFFF28482);

  /// Secondary accent colour for neutral surfaces and controls (muted
  /// green/grey #84A59D).
  static const Color secondary = Color(0xFF84A59D);

  /// Additional accent colour used for subtle highlights (soft pink #F5CAC3).
  static const Color tertiary = Color(0xFFF5CAC3);

  /// Text colour on light backgrounds.
  static const Color textPrimary = Color(0xFF2B2B2B);

  /// Colour for hints and secondary text (slightly darker grey).
  static const Color hint = Color(0xFF666666);
}

/// Central definition of the application's [ThemeData]. This theme is based on
/// Material 3 but tweaked to reflect the custom colours and rounded shapes from
/// the provided UI design. Input decorations, button styles and card styling
/// live here to reduce duplication within widgets.
class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    // Use the Inter font throughout the app. We derive our text theme from
    // the base text theme and then override colours and weights where
    // necessary. `google_fonts` takes care of bundling the font assets.
    final interTextTheme = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      cardColor: AppColors.card,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card,
        elevation: 0,
        titleTextStyle: interTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      textTheme: interTextTheme.copyWith(
        titleLarge: interTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: interTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: interTextTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: interTextTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        bodySmall: interTextTheme.bodySmall?.copyWith(
          color: AppColors.hint,
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: interTextTheme.bodyMedium?.copyWith(color: AppColors.hint, fontSize: 14),
        labelStyle: interTextTheme.bodyMedium?.copyWith(color: AppColors.hint, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: interTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: interTextTheme.bodyMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}