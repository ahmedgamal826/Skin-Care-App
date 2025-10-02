import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff8F4A50),
      surfaceTint: Color(0xff904b3e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdad4),
      onPrimaryContainer: Color(0xff3a0a04),
      secondary: Color(0xff775651),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdad4),
      onSecondaryContainer: Color(0xff2c1511),
      tertiary: Color(0xff6f5c2e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffae0a6),
      onTertiaryContainer: Color(0xff251a00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff8f6),
      onBackground: Color(0xff231918),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff231918),
      surfaceVariant: Color(0xfff5ddd9),
      onSurfaceVariant: Color(0xff534340),
      outline: Color(0xff857370),
      outlineVariant: Color(0xffd8c2be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      inverseOnSurface: Color(0xffffedea),
      inversePrimary: Color(0xffffb4a6),
      primaryFixed: Color(0xffffdad4),
      onPrimaryFixed: Color(0xff3a0a04),
      primaryFixedDim: Color(0xffffb4a6),
      onPrimaryFixedVariant: Color(0xff733429),
      secondaryFixed: Color(0xffffdad4),
      onSecondaryFixed: Color(0xff2c1511),
      secondaryFixedDim: Color(0xffe7bdb5),
      onSecondaryFixedVariant: Color(0xff5d3f3a),
      tertiaryFixed: Color(0xfffae0a6),
      onTertiaryFixed: Color(0xff251a00),
      tertiaryFixedDim: Color(0xffddc48c),
      onTertiaryFixedVariant: Color(0xff564519),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae6),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dfdb),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff6e3025),
      surfaceTint: Color(0xff904b3e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffaa6053),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff593b36),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8f6c66),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff514115),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff867242),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f6),
      onBackground: Color(0xff231918),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff231918),
      surfaceVariant: Color(0xfff5ddd9),
      onSurfaceVariant: Color(0xff4f3f3d),
      outline: Color(0xff6c5b58),
      outlineVariant: Color(0xff897773),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      inverseOnSurface: Color(0xffffedea),
      inversePrimary: Color(0xffffb4a6),
      primaryFixed: Color(0xffaa6053),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8d483c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8f6c66),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff75544e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff867242),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6c5a2c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae6),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dfdb),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff431008),
      surfaceTint: Color(0xff904b3e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6e3025),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff341c17),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff593b36),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2d2000),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff514115),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f6),
      onBackground: Color(0xff231918),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xfff5ddd9),
      onSurfaceVariant: Color(0xff2e211e),
      outline: Color(0xff4f3f3d),
      outlineVariant: Color(0xff4f3f3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffe7e2),
      primaryFixed: Color(0xff6e3025),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff511b12),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff593b36),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff402621),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff514115),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff392b02),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae6),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dfdb),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4a6),
      surfaceTint: Color(0xffffb4a6),
      onPrimary: Color(0xff561e15),
      primaryContainer: Color(0xff733429),
      onPrimaryContainer: Color(0xffffdad4),
      secondary: Color(0xffe7bdb5),
      onSecondary: Color(0xff442a25),
      secondaryContainer: Color(0xff5d3f3a),
      onSecondaryContainer: Color(0xffffdad4),
      tertiary: Color(0xffddc48c),
      onTertiary: Color(0xff3d2e04),
      tertiaryContainer: Color(0xff564519),
      onTertiaryContainer: Color(0xfffae0a6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff1a1110),
      onBackground: Color(0xfff1dfdb),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfff1dfdb),
      surfaceVariant: Color(0xff534340),
      onSurfaceVariant: Color(0xffd8c2be),
      outline: Color(0xffa08c89),
      outlineVariant: Color(0xff534340),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfdb),
      inverseOnSurface: Color(0xff392e2c),
      inversePrimary: Color(0xff904b3e),
      primaryFixed: Color(0xffffdad4),
      onPrimaryFixed: Color(0xff3a0a04),
      primaryFixedDim: Color(0xffffb4a6),
      onPrimaryFixedVariant: Color(0xff733429),
      secondaryFixed: Color(0xffffdad4),
      onSecondaryFixed: Color(0xff2c1511),
      secondaryFixedDim: Color(0xffe7bdb5),
      onSecondaryFixedVariant: Color(0xff5d3f3a),
      tertiaryFixed: Color(0xfffae0a6),
      onTertiaryFixed: Color(0xff251a00),
      tertiaryFixedDim: Color(0xffddc48c),
      onTertiaryFixedVariant: Color(0xff564519),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3230),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffbaad),
      surfaceTint: Color(0xffffb4a6),
      onPrimary: Color(0xff330502),
      primaryContainer: Color(0xffcc7b6d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffecc1b9),
      onSecondary: Color(0xff26100c),
      secondaryContainer: Color(0xffae8881),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe1c890),
      onTertiary: Color(0xff1e1500),
      tertiaryContainer: Color(0xffa48e5b),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff1a1110),
      onBackground: Color(0xfff1dfdb),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfffff9f8),
      surfaceVariant: Color(0xff534340),
      onSurfaceVariant: Color(0xffdcc6c2),
      outline: Color(0xffb39e9b),
      outlineVariant: Color(0xff927f7b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfdb),
      inverseOnSurface: Color(0xff322826),
      inversePrimary: Color(0xff74352a),
      primaryFixed: Color(0xffffdad4),
      onPrimaryFixed: Color(0xff2c0200),
      primaryFixedDim: Color(0xffffb4a6),
      onPrimaryFixedVariant: Color(0xff5e241a),
      secondaryFixed: Color(0xffffdad4),
      onSecondaryFixed: Color(0xff200b07),
      secondaryFixedDim: Color(0xffe7bdb5),
      onSecondaryFixedVariant: Color(0xff4b2f2a),
      tertiaryFixed: Color(0xfffae0a6),
      onTertiaryFixed: Color(0xff181000),
      tertiaryFixedDim: Color(0xffddc48c),
      onTertiaryFixedVariant: Color(0xff443409),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3230),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f8),
      surfaceTint: Color(0xffffb4a6),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffbaad),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffecc1b9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffffaf6),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe1c890),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff1a1110),
      onBackground: Color(0xfff1dfdb),
      surface: Color(0xff1a1110),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff534340),
      onSurfaceVariant: Color(0xfffff9f8),
      outline: Color(0xffdcc6c2),
      outlineVariant: Color(0xffdcc6c2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dfdb),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff4e180f),
      primaryFixed: Color(0xffffe0da),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffbaad),
      onPrimaryFixedVariant: Color(0xff330502),
      secondaryFixed: Color(0xffffe0da),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffecc1b9),
      onSecondaryFixedVariant: Color(0xff26100c),
      tertiaryFixed: Color(0xffffe4aa),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe1c890),
      onTertiaryFixedVariant: Color(0xff1e1500),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3230),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
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
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
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
