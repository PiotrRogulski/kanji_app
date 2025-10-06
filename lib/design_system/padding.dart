import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppPadding extends StatelessWidget {
  const AppPadding({super.key, required this.padding, required this.child});

  final AppEdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class AppSliverPadding extends StatelessWidget {
  const AppSliverPadding({
    super.key,
    required this.padding,
    required this.sliver,
  });

  final AppEdgeInsets padding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(padding: padding, sliver: sliver);
  }
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
