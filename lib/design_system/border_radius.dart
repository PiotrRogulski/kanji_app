import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppBorderRadius extends BorderRadiusDirectional {
  AppBorderRadius.circular(AppUnit super.radius) : super.circular();

  AppBorderRadius.vertical({AppUnit top = .zero, AppUnit bottom = .zero})
    : super.vertical(top: .circular(top), bottom: .circular(bottom));

  AppBorderRadius.horizontal({AppUnit start = .zero, AppUnit end = .zero})
    : super.horizontal(start: .circular(start), end: .circular(end));

  const AppBorderRadius._only({
    super.topStart,
    super.topEnd,
    super.bottomStart,
    super.bottomEnd,
  }) : super.only();

  const AppBorderRadius._zero() : super.all(.zero);
  static const zero = AppBorderRadius._zero();

  @override
  AppBorderRadius operator *(double other) => ._only(
    topStart: topStart * other,
    topEnd: topEnd * other,
    bottomStart: bottomStart * other,
    bottomEnd: bottomEnd * other,
  );
}
