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
  required final Axis direction,
  required final Axis itemDirection,
  required final String scrollToTopTooltip,
  final VoidCallback? onScrollToTop,
}) extends HookWidget {
  static const height = 64.0;
  static const sidebarWidth = 200.0;

  static const _sidebarItemHeight = 56.0;
  static const _buttonGap = AppUnit.small;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final horizontal = direction == .horizontal;

    final split = useValueSpring(
      onScrollToTop != null ? 1 : 0,
      spring: Springs.expressiveDefaultSpatial,
    );
    final hasButton = onScrollToTop != null || split > 0.01;

    return AppGlassLayer(
      child: LiquidGlassBlendGroup(
        blend: 24,
        child: Flex(
          direction: direction,
          mainAxisSize: .min,
          children: [
            Flexible(
              flex: horizontal ? 1 : 0,
              fit: .tight,
              child: LiquidGlass.grouped(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: horizontal
                      ? height / 2
                      : _sidebarItemHeight / 2 + _Destinations._inlineInset,
                ),
                shadows: appLiquidGlassShadows,
                child: Material(
                  type: .transparency,
                  child: SizedBox(
                    width: horizontal ? null : sidebarWidth,
                    height: horizontal
                        ? height
                        : _sidebarItemHeight * destinations.length +
                              _Destinations._inlineInset * 2,
                    child: _Destinations(
                      destinations: destinations,
                      selectedIndex: selectedIndex,
                      onSelected: onSelected,
                      direction: direction,
                      itemDirection: itemDirection,
                    ),
                  ),
                ),
              ),
            ),
            if (hasButton)
              // The button is laid out from the end of the bar, over the end
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
  required final Axis direction,
  required final Axis itemDirection,
}) extends HookWidget {
  static const _inlineInset = 12.0;

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
    final stretch =
        (leading - trailing).abs() *
        switch (direction) {
          .horizontal => 28,
          .vertical => 12,
        };

    return Padding(
      padding: switch (itemDirection) {
        .vertical => .zero,
        .horizontal => const .all(_inlineInset),
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slot = switch (direction) {
            .horizontal => Size(
              constraints.maxWidth / destinations.length,
              constraints.maxHeight,
            ),
            .vertical => Size(
              constraints.maxWidth,
              constraints.maxHeight / destinations.length,
            ),
          };
          final inSlot = switch (itemDirection) {
            .vertical => Alignment.topCenter.inscribe(
              NavigationItem.stackedIndicatorSize,
              const Offset(0, NavigationItem.stackedIndicatorTop) & slot,
            ),
            .horizontal => Offset.zero & slot,
          };
          final indicator = switch (direction) {
            .horizontal => Rect.fromLTRB(
              inSlot.left - stretch,
              inSlot.top,
              inSlot.right + stretch,
              inSlot.bottom,
            ).translate(slot.width * position, 0),
            .vertical => Rect.fromLTRB(
              inSlot.left,
              inSlot.top - stretch,
              inSlot.right,
              inSlot.bottom + stretch,
            ).translate(0, slot.height * position),
          };

          return Stack(
            clipBehavior: .none,
            children: [
              PositionedDirectional(
                start: indicator.left,
                top: indicator.top,
                width: indicator.width,
                height: indicator.height,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: colorScheme.secondaryContainer,
                  ),
                ),
              ),
              Flex(
                direction: direction,
                crossAxisAlignment: .stretch,
                children: [
                  for (final (index, destination) in destinations.indexed)
                    Expanded(
                      child: NavigationItem(
                        destination: destination,
                        selected: index == selectedIndex,
                        onTap: () => onSelected(index),
                        direction: itemDirection,
                        alignment: direction == .vertical
                            ? .centerStart
                            : .center,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
