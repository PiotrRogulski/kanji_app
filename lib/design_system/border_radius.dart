import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppBorderRadius extends BorderRadius {
  AppBorderRadius.circular(AppUnit super.radius) : super.circular();

  AppBorderRadius.vertical({AppUnit? top, AppUnit? bottom})
    : super.vertical(
        top: top != null ? .circular(top) : .zero,
        bottom: bottom != null ? .circular(bottom) : .zero,
      );

  AppBorderRadius.horizontal({AppUnit? left, AppUnit? right})
    : super.horizontal(
        left: left != null ? .circular(left) : .zero,
        right: right != null ? .circular(right) : .zero,
      );

  const AppBorderRadius._zero() : super.all(.zero);
  static const zero = AppBorderRadius._zero();
}
