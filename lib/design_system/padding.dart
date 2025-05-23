import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppPadding extends EdgeInsetsDirectional {
  const AppPadding.all(AppUnit super.value) : super.all();

  const AppPadding.only({
    AppUnit? start,
    AppUnit? top,
    AppUnit? end,
    AppUnit? bottom,
  }) : super.only(
         start: start ?? 0,
         top: top ?? 0,
         end: end ?? 0,
         bottom: bottom ?? 0,
       );

  const AppPadding.symmetric({AppUnit? horizontal, AppUnit? vertical})
    : super.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0);

  static const zero = AppPadding.only();
}
