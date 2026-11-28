import 'dart:math';
import 'dart:ui';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/navigation/navigation_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

const _indicatorId = 'indicator';

class const AppNavigationRail({
  super.key,
  required final List<AppDestination> destinations,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
}) extends HookWidget {
  static const width = 160.0;

  static const _itemHeight = 56.0;
  static const _itemExtent = 60.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final leading = useValueSpring(
      selectedIndex.toDouble(),
      spring: Springs.expressiveFastSpatial,
    );
    final trailing = useValueSpring(
      selectedIndex.toDouble(),
      spring: Springs.expressiveDefaultSpatial,
    );

    return SizedBox(
      width: width,
      height: _itemExtent * destinations.length,
      child: CustomMultiChildLayout(
        delegate: _RailLayout(
          count: destinations.length,
          leading: leading,
          trailing: trailing,
          textDirection: Directionality.of(context),
        ),
        children: [
          LayoutId(
            id: _indicatorId,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: colorScheme.secondaryContainer,
              ),
            ),
          ),
          for (final (index, destination) in destinations.indexed)
            LayoutId(
              id: index,
              child: NavigationItem(
                destination: destination,
                selected: index == selectedIndex,
                onTap: () => onSelected(index),
                direction: .horizontal,
              ),
            ),
        ],
      ),
    );
  }
}

class _RailLayout({
  required final int count,
  required final double leading,
  required final double trailing,
  required final TextDirection textDirection,
}) extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    Offset at(double width, double top) =>
        .new(textDirection == .ltr ? 0 : size.width - width, top);

    final widths = [
      for (var index = 0; index < count; index++)
        layoutChild(
          index,
          .new(
            maxWidth: size.width,
            minHeight: AppNavigationRail._itemHeight,
            maxHeight: AppNavigationRail._itemHeight,
          ),
        ).width,
    ];
    for (final (index, width) in widths.indexed) {
      positionChild(index, at(width, index * AppNavigationRail._itemExtent));
    }

    final first = min(leading, trailing);
    final last = max(leading, trailing);
    final position = clampDouble((first + last) / 2, 0, count - 1);
    final width = lerpDouble(
      widths[position.floor()],
      widths[position.ceil()],
      position - position.floor(),
    )!;

    layoutChild(
      _indicatorId,
      .tightFor(
        width: width,
        height:
            (last - first) * AppNavigationRail._itemExtent +
            AppNavigationRail._itemHeight,
      ),
    );
    positionChild(
      _indicatorId,
      at(width, first * AppNavigationRail._itemExtent),
    );
  }

  @override
  bool shouldRelayout(_RailLayout old) =>
      count != old.count ||
      leading != old.leading ||
      trailing != old.trailing ||
      textDirection != old.textDirection;
}
