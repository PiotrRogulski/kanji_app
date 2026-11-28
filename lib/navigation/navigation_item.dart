import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const AppDestination({
  required final AppIconData icon,
  required final String label,
});

class const NavigationItem({
  super.key,
  required final AppDestination destination,
  required final bool selected,
  required final VoidCallback onTap,
  required final Axis direction,
  final AlignmentGeometry alignment = .center,
}) extends StatelessWidget {
  static const stackedIndicatorSize = Size(64, 32);
  static const stackedIndicatorTop = 6.0;

  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: _Item(
        destination: destination,
        selected: selected,
        onTap: onTap,
        direction: direction,
        alignment: alignment,
      ),
    );
  }
}

class const _Item({
  required final AppDestination destination,
  required final bool selected,
  required final VoidCallback onTap,
  required final Axis direction,
  required final AlignmentGeometry alignment,
}) extends HookWidget {
  static const _pressedScale = 0.88;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pressed = DynamicWeight.of(context).pressed;
    final scale = useValueSpring(
      pressed ? _pressedScale : 1,
      spring: Springs.expressiveFastSpatial,
    );

    final color = useColorSpring(
      selected ? colorScheme.onSecondaryContainer : colorScheme.onSurface,
    );

    final icon = AppIcon(
      destination.icon,
      size: .large,
      color: color,
      fill: selected ? 1 : null,
      weight: selected ? .bold : null,
    );
    Widget label(TextStyle? style, TextAlign textAlign) => DynamicWeightText(
      destination.label,
      weight: selected ? .bold : null,
      textAlign: textAlign,
      maxLines: 1,
      overflow: .fade,
      softWrap: false,
      style: style?.apply(color: color),
    );

    return Semantics(
      selected: selected,
      child: AppInkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Transform.scale(
          scale: scale,
          child: switch (direction) {
            .vertical => Padding(
              padding: const .only(top: NavigationItem.stackedIndicatorTop),
              child: Column(
                spacing: AppUnit.xsmall,
                children: [
                  SizedBox(
                    height: NavigationItem.stackedIndicatorSize.height,
                    child: Center(child: icon),
                  ),
                  label(theme.textTheme.labelMedium, .center),
                ],
              ),
            ),
            .horizontal => Align(
              alignment: alignment,
              child: AppPadding(
                padding: const .symmetric(horizontal: .medium),
                child: Row(
                  mainAxisSize: .min,
                  spacing: AppUnit.small,
                  children: [
                    icon,
                    Flexible(child: label(theme.textTheme.labelLarge, .start)),
                  ],
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}
