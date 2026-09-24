import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design direction: dark-mode-first, near-black (never pure black) base,
/// a single high-energy accent reserved for progress/CTAs, and oversized
/// tabular-figure numerals for live stats — the numbers are the hero
/// element, not a caption. Matches what's currently working across
/// Whoop/Fitbod/Strava-style dashboards rather than generic Material blue.
class AppTheme {
  // Single accent, used identically in both themes so light/dark feel like
  // the same brand rather than two different palettes.
  static const Color accent = Color(0xFF34D399); // emerald-400
  static const Color accentDeep = Color(0xFF10B981); // emerald-500, light-mode contrast

  static const Color darkBg = Color(0xFF0B0F0D); // near-black, warm-green undertone
  static const Color darkSurface = Color(0xFF151A17);
  static const Color darkSurfaceElevated = Color(0xFF1D2420);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkError = Color(0xFFF87171);

  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInputFill = Color(0xFFF3F4F6);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightError = Color(0xFFEF4444);

  /// Oversized, tight, tabular-figure style for hero numbers — current
  /// weight, streak count, reps — per the "numbers are the hero element"
  /// pattern. Size is tuned for a stat card; scale it up for a full-screen
  /// live number.
  static TextStyle statNumberStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.spaceGrotesk(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: -1.0,
      color: isDark ? darkTextPrimary : lightTextPrimary,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);
    final textTheme = GoogleFonts.spaceGroteskTextTheme(base.textTheme);

    return base.copyWith(
      primaryColor: accentDeep,
      scaffoldBackgroundColor: lightBg,
      colorScheme: ColorScheme.light(
        primary: accentDeep,
        secondary: accent,
        error: lightError,
        surface: lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accentDeep, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentDeep,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentDeep,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: lightTextPrimary,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, color: lightTextPrimary),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14, color: lightTextSecondary),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    final textTheme = GoogleFonts.spaceGroteskTextTheme(base.textTheme);

    return base.copyWith(
      primaryColor: accent,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent,
        error: darkError,
        surface: darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: const Color(0xFF06251A),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: darkTextPrimary,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, color: darkTextPrimary),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14, color: darkTextSecondary),
      ),
    );
  }
}
