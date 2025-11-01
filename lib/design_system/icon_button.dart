import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
    this.fill,
    this.iconPadding,
  });

  final AppIconData icon;
  final AppUnit iconSize;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fill;
  final AppEdgeInsets? iconPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: .transparency,
      shape: const CircleBorder(),
      clipBehavior: .antiAlias,
      child: AppInkWell(
        onTap: onPressed,
        child: AppPadding(
          padding: iconPadding ?? const .all(.small),
          child: AnimatedSwitcher(
            duration: Durations.medium1,
            switchInCurve: Curves.easeInOutCubicEmphasized,
            switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: AppIcon(
              key: ValueKey(icon),
              icon,
              size: iconSize,
              color: color,
              fill: fill,
            ),
          ),
        ),
      ),
    );
  }
}
