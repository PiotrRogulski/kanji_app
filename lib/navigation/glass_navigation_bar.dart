import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

class const AppGlassDestination({
  required final AppIconData icon,
  required final String label,
});

class const AppGlassNavigationBar({
  super.key,
  required final List<AppGlassDestination> destinations,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
  required final String scrollToTopTooltip,
  final VoidCallback? onScrollToTop,
}) extends HookWidget {
  static const height = 64.0;

  static const _buttonGap = AppUnit.small;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final split = useValueSpring(
      onScrollToTop != null ? 1 : 0,
      spring: Springs.expressiveDefaultSpatial,
    );
    final hasButton = onScrollToTop != null || split > 0.01;

    return AppGlassLayer(
      child: LiquidGlassBlendGroup(
        blend: 24,
        child: Row(
          children: [
            Expanded(
              child: LiquidGlass.grouped(
                shape: const LiquidRoundedSuperellipse(
                  borderRadius: height / 2,
                ),
                shadows: appLiquidGlassShadows,
                child: Material(
                  type: .transparency,
                  child: SizedBox(
                    height: height,
                    child: _Destinations(
                      destinations: destinations,
                      selectedIndex: selectedIndex,
                      onSelected: onSelected,
                    ),
                  ),
                ),
              ),
            ),
            if (hasButton)
              // The button is laid out from the end of the row, over the end
              // of the bar, which is as round as it is. So with no room at
              // all it's a part of the bar, and it comes apart as it gets it.
              SizedBox(
                width: max(0, (height + _buttonGap) * split),
                height: height,
                child: OverflowBox(
                  alignment: .centerEnd,
                  minWidth: height,
                  maxWidth: height,
                  child: LiquidGlass.grouped(
                    shape: const LiquidOval(),
                    shadows: appLiquidGlassShadows,
                    child: SizedBox.square(
                      dimension: height,
                      child: Opacity(
                        opacity: split.clamp(0, 1),
                        child: Tooltip(
                          message: scrollToTopTooltip,
                          child: DynamicWeight(
                            child: AppIconButton(
                              icon: .arrowUpward,
                              iconSize: .large,
                              iconPadding: .all(
                                AppUnit.medium + AppUnit.xsmall,
                              ),
                              color: colorScheme.onSurface,
                              onPressed: onScrollToTop,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class const _Destinations({
  required final List<AppGlassDestination> destinations,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
}) extends HookWidget {
  static const _indicatorSize = Size(64, 32);
  static const _indicatorTop = 6.0;

  static const _indicatorStretch = 56.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final count = destinations.length;
    // One end of the indicator gets to where it's headed sooner than the
    // other. So it stretches out as it sets off, and gathers itself as it
    // arrives, with no jump in its size at either end.
    final leading = useValueSpring(
      selectedIndex.toDouble(),
      spring: Springs.expressiveFastSpatial,
    );
    final trailing = useValueSpring(
      selectedIndex.toDouble(),
      spring: Springs.expressiveDefaultSpatial,
    );
    final position = (leading + trailing) / 2;
    final distance = (leading - trailing).abs();

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: AlignmentDirectional(
              count < 2 ? 0 : lerpDouble(-1, 1, position / (count - 1))!,
              -1,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / count,
              child: Align(
                alignment: .topCenter,
                child: Container(
                  margin: const .only(top: _indicatorTop),
                  width: _indicatorSize.width + _indicatorStretch * distance,
                  height: _indicatorSize.height,
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: colorScheme.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            for (final (index, destination) in destinations.indexed)
              Expanded(
                child: DynamicWeight(
                  child: _Destination(
                    destination: destination,
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class const _Destination({
  required final AppGlassDestination destination,
  required final bool selected,
  required final VoidCallback onTap,
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
          child: Padding(
            padding: const .only(top: _Destinations._indicatorTop),
            child: Column(
              spacing: AppUnit.xsmall,
              children: [
                SizedBox(
                  height: _Destinations._indicatorSize.height,
                  child: Center(
                    child: AppIcon(
                      destination.icon,
                      size: .large,
                      color: color,
                      fill: selected ? 1 : null,
                      weight: selected ? .bold : null,
                    ),
                  ),
                ),
                DynamicWeightText(
                  destination.label,
                  weight: selected ? .bold : null,
                  textAlign: .center,
                  maxLines: 1,
                  overflow: .fade,
                  softWrap: false,
                  style: theme.textTheme.labelMedium?.apply(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
