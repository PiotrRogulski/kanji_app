import 'dart:math';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/navigation/navigation_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

class const AppGlassNavigationBar({
  super.key,
  required final List<AppDestination> destinations,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
  required final Axis itemDirection,
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
                      itemDirection: itemDirection,
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
  required final List<AppDestination> destinations,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
  required final Axis itemDirection,
}) extends HookWidget {
  static const _indicatorStretch = 56.0;

  static const _inlineIndicatorHeight = 40.0;
  static const _inlineIndicatorInset =
      (AppGlassNavigationBar.height - _inlineIndicatorHeight) / 2;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final slot = constraints.maxWidth / destinations.length;
        final (top, size) = switch (itemDirection) {
          .vertical => (
            NavigationItem.stackedIndicatorTop,
            NavigationItem.stackedIndicatorSize,
          ),
          .horizontal => (
            _inlineIndicatorInset,
            Size(slot - _inlineIndicatorInset * 2, _inlineIndicatorHeight),
          ),
        };
        final width = size.width + _indicatorStretch * distance;

        return Stack(
          children: [
            PositionedDirectional(
              start: slot * (position + 0.5) - width / 2,
              top: top,
              width: width,
              height: size.height,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: colorScheme.secondaryContainer,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: .stretch,
              children: [
                for (final (index, destination) in destinations.indexed)
                  Expanded(
                    child: NavigationItem(
                      destination: destination,
                      selected: index == selectedIndex,
                      onTap: () => onSelected(index),
                      direction: itemDirection,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
