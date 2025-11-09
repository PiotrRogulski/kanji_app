import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppPadding extends Padding {
  const AppPadding({
    super.key,
    required AppEdgeInsets super.padding,
    super.child,
  });
}

class AppSliverPadding extends SliverPadding {
  const AppSliverPadding({
    super.key,
    required AppEdgeInsets super.padding,
    super.sliver,
  });
}

class AppEdgeInsets extends EdgeInsetsDirectional {
  const AppEdgeInsets.all(AppUnit super.value) : super.all();

  const AppEdgeInsets.only({
    AppUnit super.start = .zero,
    AppUnit super.top = .zero,
    AppUnit super.end = .zero,
    AppUnit super.bottom = .zero,
  }) : super.only();

  const AppEdgeInsets.symmetric({
    AppUnit super.horizontal = .zero,
    AppUnit super.vertical = .zero,
  }) : super.symmetric();

  static const zero = AppEdgeInsets.only();
}
