import 'package:flutter/material.dart';

ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: const .new(0xFFC8AE7E));

  final baseTheme = ThemeData.from(colorScheme: colorScheme);

  return baseTheme.copyWith(
    splashFactory: InkSparkle.splashFactory,
    splashColor: colorScheme.primary.withValues(alpha: 0.25),
    highlightColor: colorScheme.primary.withValues(alpha: 0.2),
    hoverColor: colorScheme.primary.withValues(alpha: 0.1),
    focusColor: colorScheme.primary.withValues(alpha: 0.2),
    textTheme: baseTheme.textTheme.applyFontFamilies(),
    cardTheme: baseTheme.cardTheme.copyWith(
      clipBehavior: .antiAlias,
      margin: .zero,
    ),
    searchBarTheme: .new(
      elevation: .all(0),
      textStyle: .all(const TextStyle().body),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {.android: PredictiveBackPageTransitionsBuilder()},
    ),
  );
}

extension on TextTheme {
  TextTheme applyFontFamilies() => copyWith(
    displayLarge: displayLarge?.display,
    displayMedium: displayMedium?.display,
    displaySmall: displaySmall?.display,
    headlineLarge: headlineLarge?.display,
    headlineMedium: headlineMedium?.display,
    headlineSmall: headlineSmall?.display,
    bodyLarge: bodyLarge?.body,
    bodyMedium: bodyMedium?.body,
    bodySmall: bodySmall?.body,
    titleLarge: titleLarge?.body,
    titleMedium: titleMedium?.body,
    titleSmall: titleSmall?.body,
    labelLarge: labelLarge?.body,
    labelMedium: labelMedium?.body,
    labelSmall: labelSmall?.body,
  );
}

extension on TextStyle {
  TextStyle get display => copyWith(
    fontFamily: 'EB Garamond',
    fontFamilyFallback: ['Yu Kyokasho', 'KleeOne'],
  ).applyAxes;

  TextStyle get body => copyWith(
    fontFamily: 'Roboto Flex',
    fontFamilyFallback: ['Noto Sans JP'],
  ).applyAxes;

  TextStyle get applyAxes => copyWith(
    fontVariations: [
      .weight((fontWeight ?? .normal).value.toDouble()),
      if (fontSize case final size?) .opticalSize(size),
    ],
  );
}
