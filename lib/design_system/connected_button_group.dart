import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const AppButtonSegment<T>({
  required final T value,
  required final String label,
});

class const AppConnectedButtonGroup<T>({
  super.key,
  required final List<AppButtonSegment<T>> segments,
  required final T selected,
  required final ValueChanged<T> onSelectionChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: AppUnit.tiny,
        crossAxisAlignment: .stretch,
        children: [
          for (final (index, segment) in segments.indexed)
            Expanded(
              child: DynamicWeight(
                child: _Segment(
                  segment: segment,
                  selectedValue: selected,
                  onSelectionChanged: onSelectionChanged,
                  position: .fromIndex(index, segments.length),
                ),
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

  factory fromIndex(int index, int length) {
    if (index == 0) {
      return first;
    } else if (index == length - 1) {
      return last;
    } else {
      return middle;
    }
  }
}

class const _Segment<T>({
  required final AppButtonSegment<T> segment,
  required final T selectedValue,
  required final ValueChanged<T> onSelectionChanged,
  required final _SegmentPosition position,
  super.key,
}) extends HookWidget {
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
      spring: selected ? null : Springs.expressiveFastSpatial,
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
                    child: AppIcon(
                      .check,
                      size: .large,
                      color: rawContentColor,
                      weight: .light,
                    ),
                  ),
                ),
                DynamicWeightText(
                  segment.label,
                  weight: selected ? .bold : null,
                  textAlign: .center,
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
