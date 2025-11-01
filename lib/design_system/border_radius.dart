import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppRadius extends Radius {
  const AppRadius._circular(super.radius) : super.circular();
  const factory AppRadius.circular(AppUnit radius) = AppRadius._circular;

  static const zero = AppRadius._circular(0);
}

class AppBorderRadius extends BorderRadius {
  AppBorderRadius.circular(AppUnit super.radius) : super.circular();

  AppBorderRadius.vertical({AppUnit? top, AppUnit? bottom})
    : super.vertical(
        top: top != null ? AppRadius.circular(top) : AppRadius.zero,
        bottom: bottom != null ? AppRadius.circular(bottom) : AppRadius.zero,
      );

  AppBorderRadius.horizontal({AppUnit? left, AppUnit? right})
    : super.horizontal(
        left: left != null ? AppRadius.circular(left) : AppRadius.zero,
        right: right != null ? AppRadius.circular(right) : AppRadius.zero,
      );

  const AppBorderRadius._zero() : super.all(AppRadius.zero);
  static const zero = AppBorderRadius._zero();
}
