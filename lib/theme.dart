import "package:flutter/material.dart";

import 'app_colors.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // ─── Light Scheme ───────────────────────────────────────────────
  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,

      // Primary — Mint Teal
      primary: AppColors.mintTeal,
      surfaceTint: AppColors.mintTeal,
      onPrimary: AppColors.darkTeal,
      primaryContainer: AppColors.lightMint,
      onPrimaryContainer: AppColors.darkTeal,

      // Secondary — Lavender
      secondary: AppColors.lavender,
      onSecondary: AppColors.darkLavender,
      secondaryContainer: AppColors.lightLavender,
      onSecondaryContainer: AppColors.darkLavender,

      // Tertiary — Mauve
      tertiary: AppColors.mauve,
      onTertiary: AppColors.darkMauve,
      tertiaryContainer: AppColors.lightMauve,
      onTertiaryContainer: AppColors.darkMauve,

      // Error — Soft red that harmonizes with the palette
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      // Background & Surface — Warm peach tones
      background: AppColors.lightPeach,
      onBackground: AppColors.darkWarm,
      surface: AppColors.lightPeach,
      onSurface: AppColors.darkWarm,
      surfaceVariant: AppColors.peach,
      onSurfaceVariant: Color(0xFF534340),

      // Outlines
      outline: AppColors.mauve,
      outlineVariant: AppColors.softPink,

      // System
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      // Inverse
      inverseSurface: AppColors.darkWarm,
      inverseOnSurface: AppColors.cream,
      inversePrimary: AppColors.lightMint,

      // Fixed variants
      primaryFixed: AppColors.lightMint,
      onPrimaryFixed: AppColors.darkTeal,
      primaryFixedDim: AppColors.mintTeal,
      onPrimaryFixedVariant: Color(0xFF3A6066),
      secondaryFixed: AppColors.lightLavender,
      onSecondaryFixed: AppColors.darkLavender,
      secondaryFixedDim: AppColors.lavender,
      onSecondaryFixedVariant: Color(0xFF4A4854),
      tertiaryFixed: AppColors.lightMauve,
      onTertiaryFixed: AppColors.darkMauve,
      tertiaryFixedDim: AppColors.mauve,
      onTertiaryFixedVariant: Color(0xFF564F56),

      // Surface containers (lightest → darkest)
      surfaceDim: AppColors.peach,
      surfaceBright: AppColors.lightPeach,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: AppColors.cream,
      surfaceContainer: AppColors.peach,
      surfaceContainerHigh: AppColors.softPink,
      surfaceContainerHighest: AppColors.mauve,
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  // ─── Light Medium Contrast ──────────────────────────────────────
  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF7AABB3),
      surfaceTint: AppColors.mintTeal,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: AppColors.mintTeal,
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFF8E8C9A),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: AppColors.lavender,
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFFA396A2),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: AppColors.mauve,
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF8C0009),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFDA342E),
      onErrorContainer: Color(0xFFFFFFFF),
      background: AppColors.lightPeach,
      onBackground: AppColors.darkWarm,
      surface: AppColors.lightPeach,
      onSurface: AppColors.darkWarm,
      surfaceVariant: AppColors.peach,
      onSurfaceVariant: Color(0xFF4F3F3D),
      outline: Color(0xFF6C5B58),
      outlineVariant: Color(0xFF897773),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.darkWarm,
      inverseOnSurface: AppColors.cream,
      inversePrimary: AppColors.lightMint,
      primaryFixed: AppColors.mintTeal,
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF7AABB3),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: AppColors.lavender,
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF8E8C9A),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: AppColors.mauve,
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFFA396A2),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: AppColors.peach,
      surfaceBright: AppColors.lightPeach,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: AppColors.cream,
      surfaceContainer: AppColors.peach,
      surfaceContainerHigh: AppColors.softPink,
      surfaceContainerHighest: AppColors.mauve,
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  // ─── Light High Contrast ────────────────────────────────────────
  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: AppColors.darkTeal,
      surfaceTint: AppColors.mintTeal,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF3A6066),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: AppColors.darkLavender,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF4A4854),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: AppColors.darkMauve,
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF564F56),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF4E0002),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF8C0009),
      onErrorContainer: Color(0xFFFFFFFF),
      background: AppColors.lightPeach,
      onBackground: AppColors.darkWarm,
      surface: AppColors.lightPeach,
      onSurface: Color(0xFF000000),
      surfaceVariant: AppColors.peach,
      onSurfaceVariant: Color(0xFF2E211E),
      outline: Color(0xFF4F3F3D),
      outlineVariant: Color(0xFF4F3F3D),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.darkWarm,
      inverseOnSurface: Color(0xFFFFFFFF),
      inversePrimary: AppColors.lightMint,
      primaryFixed: Color(0xFF3A6066),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: AppColors.darkTeal,
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF4A4854),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: AppColors.darkLavender,
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF564F56),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: AppColors.darkMauve,
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: AppColors.peach,
      surfaceBright: AppColors.lightPeach,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: AppColors.cream,
      surfaceContainer: AppColors.peach,
      surfaceContainerHigh: AppColors.softPink,
      surfaceContainerHighest: AppColors.mauve,
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  // ─── Dark Scheme ────────────────────────────────────────────────
  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: AppColors.mintTeal,
      surfaceTint: AppColors.mintTeal,
      onPrimary: Color(0xFF1A3338),
      primaryContainer: Color(0xFF3A6066),
      onPrimaryContainer: AppColors.lightMint,
      secondary: AppColors.lavender,
      onSecondary: Color(0xFF2D2C36),
      secondaryContainer: Color(0xFF4A4854),
      onSecondaryContainer: AppColors.lightLavender,
      tertiary: AppColors.mauve,
      onTertiary: Color(0xFF332D33),
      tertiaryContainer: Color(0xFF564F56),
      onTertiaryContainer: AppColors.lightMauve,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF1A1615),
      onBackground: AppColors.peach,
      surface: Color(0xFF1A1615),
      onSurface: AppColors.peach,
      surfaceVariant: Color(0xFF534340),
      onSurfaceVariant: AppColors.softPink,
      outline: Color(0xFFA08C89),
      outlineVariant: Color(0xFF534340),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.peach,
      inverseOnSurface: AppColors.darkWarm,
      inversePrimary: Color(0xFF3A6066),
      primaryFixed: AppColors.lightMint,
      onPrimaryFixed: Color(0xFF1A3338),
      primaryFixedDim: AppColors.mintTeal,
      onPrimaryFixedVariant: Color(0xFF3A6066),
      secondaryFixed: AppColors.lightLavender,
      onSecondaryFixed: Color(0xFF2D2C36),
      secondaryFixedDim: AppColors.lavender,
      onSecondaryFixedVariant: Color(0xFF4A4854),
      tertiaryFixed: AppColors.lightMauve,
      onTertiaryFixed: Color(0xFF332D33),
      tertiaryFixedDim: AppColors.mauve,
      onTertiaryFixedVariant: Color(0xFF564F56),
      surfaceDim: Color(0xFF1A1615),
      surfaceBright: Color(0xFF423735),
      surfaceContainerLowest: Color(0xFF140C0B),
      surfaceContainerLow: Color(0xFF231918),
      surfaceContainer: Color(0xFF271D1C),
      surfaceContainerHigh: Color(0xFF322826),
      surfaceContainerHighest: Color(0xFF3D3230),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  // ─── Dark Medium Contrast ───────────────────────────────────────
  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFC0DDE1),
      surfaceTint: AppColors.mintTeal,
      onPrimary: Color(0xFF0D1F22),
      primaryContainer: Color(0xFF7AABB3),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFCCCAD8),
      onSecondary: Color(0xFF1E1D26),
      secondaryContainer: Color(0xFF8E8C9A),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFD9CCD7),
      onTertiary: Color(0xFF241F24),
      tertiaryContainer: Color(0xFFA396A2),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFFFBAB1),
      onError: Color(0xFF370001),
      errorContainer: Color(0xFFFF5449),
      onErrorContainer: Color(0xFF000000),
      background: Color(0xFF1A1615),
      onBackground: AppColors.peach,
      surface: Color(0xFF1A1615),
      onSurface: Color(0xFFFFF9F8),
      surfaceVariant: Color(0xFF534340),
      onSurfaceVariant: AppColors.softPink,
      outline: Color(0xFFB39E9B),
      outlineVariant: Color(0xFF927F7B),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.peach,
      inverseOnSurface: Color(0xFF322826),
      inversePrimary: Color(0xFF3A6066),
      primaryFixed: AppColors.lightMint,
      onPrimaryFixed: Color(0xFF0A1618),
      primaryFixedDim: AppColors.mintTeal,
      onPrimaryFixedVariant: Color(0xFF2D5158),
      secondaryFixed: AppColors.lightLavender,
      onSecondaryFixed: Color(0xFF161520),
      secondaryFixedDim: AppColors.lavender,
      onSecondaryFixedVariant: Color(0xFF3A3846),
      tertiaryFixed: AppColors.lightMauve,
      onTertiaryFixed: Color(0xFF1A161A),
      tertiaryFixedDim: AppColors.mauve,
      onTertiaryFixedVariant: Color(0xFF443944),
      surfaceDim: Color(0xFF1A1615),
      surfaceBright: Color(0xFF423735),
      surfaceContainerLowest: Color(0xFF140C0B),
      surfaceContainerLow: Color(0xFF231918),
      surfaceContainer: Color(0xFF271D1C),
      surfaceContainerHigh: Color(0xFF322826),
      surfaceContainerHighest: Color(0xFF3D3230),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  // ─── Dark High Contrast ─────────────────────────────────────────
  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFF5FBFC),
      surfaceTint: AppColors.mintTeal,
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFC0DDE1),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFFFF9F8),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFCCCAD8),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFFF9FA),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFD9CCD7),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFFFF9F9),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFFFBAB1),
      onErrorContainer: Color(0xFF000000),
      background: Color(0xFF1A1615),
      onBackground: AppColors.peach,
      surface: Color(0xFF1A1615),
      onSurface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFF534340),
      onSurfaceVariant: Color(0xFFFFF9F8),
      outline: AppColors.softPink,
      outlineVariant: AppColors.softPink,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: AppColors.peach,
      inverseOnSurface: Color(0xFF000000),
      inversePrimary: AppColors.darkTeal,
      primaryFixed: Color(0xFFE0F0F2),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFC0DDE1),
      onPrimaryFixedVariant: Color(0xFF0D1F22),
      secondaryFixed: Color(0xFFE6E4F0),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFCCCAD8),
      onSecondaryFixedVariant: Color(0xFF1E1D26),
      tertiaryFixed: Color(0xFFF0E4EF),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFD9CCD7),
      onTertiaryFixedVariant: Color(0xFF241F24),
      surfaceDim: Color(0xFF1A1615),
      surfaceBright: Color(0xFF423735),
      surfaceContainerLowest: Color(0xFF140C0B),
      surfaceContainerLow: Color(0xFF231918),
      surfaceContainer: Color(0xFF271D1C),
      surfaceContainerHigh: Color(0xFF322826),
      surfaceContainerHighest: Color(0xFF3D3230),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  // ─── Theme Builder ──────────────────────────────────────────────
  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        // Input decoration theme for consistent text fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightPeach,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          centerTitle: true,
        ),
        // Card theme
        cardTheme: CardThemeData(
          color: AppColors.lightPeach,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),

        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),

          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.darkWarm; // ON
            }
            return AppColors.darkLavender; // OFF
          }),

          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),

          // 🔥 أهم سطرين
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashRadius: 0,

          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),

        // Progress indicator theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
