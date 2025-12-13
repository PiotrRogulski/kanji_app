import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppBorderRadius extends BorderRadiusDirectional {
  AppBorderRadius.circular(AppUnit super.radius) : super.circular();

  AppBorderRadius.vertical({AppUnit? top, AppUnit? bottom})
    : super.vertical(
        top: top != null ? .circular(top) : .zero,
        bottom: bottom != null ? .circular(bottom) : .zero,
      );

  AppBorderRadius.horizontal({AppUnit? start, AppUnit? end})
    : super.horizontal(
        start: start != null ? .circular(start) : .zero,
        end: end != null ? .circular(end) : .zero,
      );

  const AppBorderRadius._zero() : super.all(.zero);
  static const zero = AppBorderRadius._zero();
}
