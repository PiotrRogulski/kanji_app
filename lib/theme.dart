import 'package:flutter/material.dart';

ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFC8AE7E));

  return ThemeData.from(colorScheme: colorScheme).copyWith(
    splashFactory: InkSparkle.splashFactory,
    splashColor: colorScheme.primary.withValues(alpha: 0.3),
    highlightColor: colorScheme.primary.withValues(alpha: 0.2),
    hoverColor: colorScheme.primary.withValues(alpha: 0.1),
    focusColor: colorScheme.primary.withValues(alpha: 0.2),
  );
}
