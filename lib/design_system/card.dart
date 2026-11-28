import 'dart:math';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const AppCard({
  super.key,
  final VoidCallback? onTap,
  final AppBorderRadius? borderRadius,
  required final Widget child,
}) extends StatelessWidget {
  static const defaultRadius = AppUnit.large;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppBorderRadius.circular(defaultRadius);

    return switch (onTap) {
      final onTap? => DynamicWeight(
        child: _TappableCard(onTap: onTap, borderRadius: radius, child: child),
      ),
      null => _CardSurface(borderRadius: radius, child: child),
    };
  }
}

class const _CardSurface({
  required final BorderRadiusGeometry borderRadius,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Material(
        type: .card,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        animationDuration: .zero,
        clipBehavior: .antiAlias,
        child: child,
      ),
    );
  }
}

class const _TappableCard({
  required final VoidCallback onTap,
  required final AppBorderRadius borderRadius,
  required final Widget child,
}) extends HookWidget {
  static const _pressedRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final pressed = DynamicWeight.of(context).pressed;
    final squish = useValueSpring(
      pressed ? 1 : 0,
      spring: Springs.expressiveFastSpatial,
    );

    // Only the corners that are rounder than a pressed one get squarer. The
    // small ones, where the card meets its neighbor in a list, stay put.
    Radius pressedCorner(Radius corner) =>
        .circular(min(corner.x, _pressedRadius));
    final pressedBorderRadius = BorderRadiusDirectional.only(
      topStart: pressedCorner(borderRadius.topStart),
      topEnd: pressedCorner(borderRadius.topEnd),
      bottomStart: pressedCorner(borderRadius.bottomStart),
      bottomEnd: pressedCorner(borderRadius.bottomEnd),
    );

    return _CardSurface(
      borderRadius: .lerp(borderRadius, pressedBorderRadius, squish)!,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: AppInkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}
