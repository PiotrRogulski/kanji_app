import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AppButtonSegment<T> {
  const AppButtonSegment({required this.value, required this.label});

  final T value;
  final String label;
}

class AppConnectedButtonGroup<T> extends StatelessWidget {
  const AppConnectedButtonGroup({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  });

  final List<AppButtonSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: AppUnit.tiny,
        crossAxisAlignment: .stretch,
        children: [
          for (final (index, segment) in segments.indexed)
            Expanded(
              child: _Segment(
                segment: segment,
                selectedValue: selected,
                onSelectionChanged: onSelectionChanged,
                position: .fromIndex(index, segments.length),
              ),
            ),
        ],
      ),
    );
  }
}

enum _SegmentPosition {
  first,
  middle,
  last;

  factory _SegmentPosition.fromIndex(int index, int length) {
    if (index == 0) {
      return first;
    } else if (index == length - 1) {
      return last;
    } else {
      return middle;
    }
  }
}

class _Segment<T> extends HookWidget {
  const _Segment({
    required this.segment,
    required this.selectedValue,
    required this.onSelectionChanged,
    required this.position,
    super.key,
  });

  final AppButtonSegment<T> segment;
  final T selectedValue;
  final ValueChanged<T> onSelectionChanged;
  final _SegmentPosition position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selected = selectedValue == segment.value;

    final backgroundColor = useColorSpring(
      selected ? colorScheme.primary : colorScheme.primaryContainer,
    );
    final rawContentColor = selected
        ? colorScheme.onPrimary
        : colorScheme.onPrimaryContainer;
    final textColor = useColorSpring(rawContentColor);

    final stadiumProgress = useValueSpring(
      selected ? 1 : 0,
      ratio: selected ? 1 : 0.5,
    );

    final checkmarkScale = useValueSpring(selected ? 1 : 0);

    return Material(
      color: backgroundColor,
      shape: StadiumMorphBorder(
        fixedCornerRadius: .small,
        stadiumProgress: stadiumProgress,
      ),
      animationDuration: .zero,
      clipBehavior: .antiAlias,
      child: AppInkWell(
        onTap: () => onSelectionChanged(segment.value),
        child: AppPadding(
          padding: const .symmetric(vertical: .small, horizontal: .medium),
          child: Center(
            child: Row(
              mainAxisSize: .min,
              children: [
                Align(
                  widthFactor: checkmarkScale,
                  alignment: .centerEnd,
                  child: Transform.scale(
                    scale: checkmarkScale,
                    filterQuality: .high,
                    child: AppIcon(
                      .check,
                      size: .large,
                      color: rawContentColor,
                      weight: .light,
                    ),
                  ),
                ),
                Text(
                  segment.label,
                  style: theme.textTheme.labelLarge?.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
