import "package:flutter/material.dart"
    show Color, ColorScheme, Brightness, TextTheme, ThemeData;

class AppThemes {
  final TextTheme textTheme;

  const AppThemes(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003d3f),
      surfaceTint: Color(0xff00696c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff16797c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff213a3b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff587273),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003f2a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff327a5c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff0c1212),
      onSurfaceVariant: Color(0xff2e3838),
      outline: Color(0xff4b5454),
      outlineVariant: Color(0xff656f6f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4d7),
      primaryFixed: Color(0xff16797c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005f62),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff587273),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff40595a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff327a5c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff126045),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c7),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe3e9e9),
      surfaceContainerHigh: Color(0xffd8dede),
      surfaceContainerHighest: Color(0xffccd3d3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96eaee),
      surfaceTint: Color(0xff80d4d7),
      onPrimary: Color(0xff002b2c),
      primaryContainer: Color(0xff479da1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6e2e2),
      onSecondary: Color(0xff10292a),
      secondaryContainer: Color(0xff7b9696),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa3ecc7),
      onTertiary: Color(0xff002c1d),
      tertiaryContainer: Color(0xff589e7e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dede),
      outline: Color(0xffaab4b4),
      outlineVariant: Color(0xff889292),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff005153),
      primaryFixed: Color(0xff9cf1f4),
      onPrimaryFixed: Color(0xff001415),
      primaryFixedDim: Color(0xff80d4d7),
      onPrimaryFixedVariant: Color(0xff003d3f),
      secondaryFixed: Color(0xffcce8e8),
      onSecondaryFixed: Color(0xff001415),
      secondaryFixedDim: Color(0xffb0cccc),
      onSecondaryFixedVariant: Color(0xff213a3b),
      tertiaryFixed: Color(0xffa9f2cd),
      onTertiaryFixed: Color(0xff00150c),
      tertiaryFixedDim: Color(0xff8dd5b2),
      onTertiaryFixedVariant: Color(0xff003f2a),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4646),
      surfaceContainerLowest: Color(0xff040808),
      surfaceContainerLow: Color(0xff181f1f),
      surfaceContainer: Color(0xff232929),
      surfaceContainerHigh: Color(0xff2d3434),
      surfaceContainerHighest: Color(0xff383f3f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

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
  );

  List<ExtendedColor> get extendedColors => [];
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
