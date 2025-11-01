import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppInkWell extends StatelessWidget {
  const AppInkWell({
    super.key,
    this.onTap,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.borderRadius,
    this.child,
  });

  final GestureTapCallback? onTap;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final AppBorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      statesController: DynamicWeight.maybeOf(context)?.controller,
      onTap: onTap,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
