import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor/motor.dart';

import 'app_colors.dart';

/// requesT design tokens — text, shape, and theme derived from design.md.
abstract final class AppTheme {
  static const double radiusCard = 18;
  static const double radiusChip = 12;
  static const double radiusSheet = 24;

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: const ColorScheme.light(
        primary: AppColors.signalCoral,
        onPrimary: Colors.white,
        primaryContainer: AppColors.ember,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.deepTeal,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.mintWash,
        onSecondaryContainer: AppColors.deepTeal,
        surface: AppColors.surface,
        onSurface: AppColors.charcoal,
        onSurfaceVariant: AppColors.slate,
        error: AppColors.ember,
        outline: AppColors.mist,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      dividerColor: AppColors.mist,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: AppColors.mist),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.mist),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusChip),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.signalCoral,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepTeal,
          side: const BorderSide(color: AppColors.deepTeal, width: 1.5),
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.slate,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(color: AppColors.mist),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(color: AppColors.mist),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(
            color: AppColors.signalCoral,
            width: 1.5,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        showDragHandle: true,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusSheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepTeal,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusChip),
        ),
      ),
    );

    return base.copyWith(
      textTheme: _textTheme,
    );
  }

  /// Dark surface (design.md §4): desaturated, lightened accents on
  /// Near-Black, elevation via progressively lighter panels.
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.nearBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.coralGlow,
        onPrimary: AppColors.nearBlack,
        primaryContainer: AppColors.emberDeep,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.tealGlow,
        onSecondary: AppColors.nearBlack,
        secondaryContainer: AppColors.tealWash,
        onSecondaryContainer: AppColors.tealGlow,
        surface: AppColors.charcoalPanel,
        onSurface: AppColors.offWhite,
        onSurfaceVariant: AppColors.fog,
        error: AppColors.emberDeep,
        outline: AppColors.iron,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      dividerColor: AppColors.iron,
      textTheme: _darkTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.nearBlack,
        foregroundColor: AppColors.offWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.offWhite,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoalPanel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: AppColors.iron),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.charcoalPanel,
        side: const BorderSide(color: AppColors.iron),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.offWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusChip),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coralGlow,
          foregroundColor: AppColors.nearBlack,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tealGlow,
          side: const BorderSide(color: AppColors.tealGlow, width: 1.5),
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoalPanel,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.fog,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(color: AppColors.iron),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(color: AppColors.iron),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusChip),
          borderSide: const BorderSide(
            color: AppColors.coralGlow,
            width: 1.5,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.slatePanel,
        showDragHandle: true,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusSheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.tealWash,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.offWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusChip),
        ),
      ),
    );

    return base.copyWith(
      textTheme: _darkTextTheme,
    );
  }

  static final TextTheme _darkTextTheme = TextTheme(
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.offWhite,
      letterSpacing: -0.8,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.offWhite,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.offWhite,
      letterSpacing: -0.3,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.offWhite,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.offWhite,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.offWhite,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.offWhite,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.offWhite,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.fog,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.fog,
    ),
  );

  static final TextTheme _textTheme = TextTheme(
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.charcoal,
      letterSpacing: -0.8,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.charcoal,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
      letterSpacing: -0.3,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.charcoal,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.charcoal,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.charcoal,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.charcoal,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.slate,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.slate,
    ),
  );

  /// Tabular figures for ratings, prices, and distances (design.md §4).
  static TextStyle tabular(TextStyle base) => base.copyWith(
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// Shared motion presets (design.md §6). Durations kept 150–300ms.
abstract final class AppMotion {
  /// Elastic "send" of a posted request — compresses then overshoots.
  static const Motion send = Motion.bouncySpring(
    duration: Duration(milliseconds: 350),
    extraBounce: 0.15,
  );

  /// Cards and results arriving (subtle, quick).
  static const Motion arrive = Motion.snappySpring(
    duration: Duration(milliseconds: 280),
  );

  /// Anything appearing — press, sheet, confirm.
  static const Motion appear = Motion.smoothSpring(
    duration: Duration(milliseconds: 300),
  );

  /// Verified badge / checkmark draw-on.
  static const Motion verify = Motion.smoothSpring(
    duration: Duration(milliseconds: 250),
  );
}
