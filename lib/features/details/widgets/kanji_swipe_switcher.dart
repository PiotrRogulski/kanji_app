import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

const _bubbleSize = 64.0;
const _triggerThreshold = 100.0;

class KanjiSwipeSwitcher extends HookWidget {
  const KanjiSwipeSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final kanjiData = context.read<KanjiData>();
    final entry = context.watch<KanjiEntry>();

    final previousEntry = kanjiData.get(entry.id - 1);
    final nextEntry = kanjiData.get(entry.id + 1);

    final rawDragOffset = useState<double>(0);
    final dragOffset = useValueSpring(rawDragOffset.value, stiffness: 5000);

    void onDragEnd() {
      if (rawDragOffset.value > _triggerThreshold && previousEntry != null) {
        context.coordinator.toDetails(previousEntry.id);
      } else if (rawDragOffset.value < -_triggerThreshold &&
          nextEntry != null) {
        context.coordinator.toDetails(nextEntry.id);
      }
      rawDragOffset.value = 0;
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        rawDragOffset.value += details.delta.dx;
      },
      onHorizontalDragCancel: onDragEnd,
      onHorizontalDragEnd: (_) => onDragEnd(),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          if (previousEntry != null && dragOffset > 0)
            _PositionedKanjiPreview(previousEntry, dragOffset),
          if (nextEntry != null && dragOffset < 0)
            _PositionedKanjiPreview(nextEntry, dragOffset),
        ],
      ),
    );
  }
}

class _PositionedKanjiPreview extends StatelessWidget {
  const _PositionedKanjiPreview(this.entry, this.offset);

  final KanjiEntry entry;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: offset > 0 ? .ltr : .rtl,
      top: 0,
      bottom: 0,
      start: min(offset.abs(), _triggerThreshold) - _bubbleSize,
      child: _KanjiPreviewBubble(entry, offset: offset.abs()),
    );
  }
}

class _KanjiPreviewBubble extends HookWidget {
  _KanjiPreviewBubble(this.entry, {required double offset})
    : percentArmed = (offset / _triggerThreshold).clamp(0, 1),
      stretch = max(0, offset - _triggerThreshold);

  final KanjiEntry entry;
  final double percentArmed;
  final double stretch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isArmed = percentArmed == 1;
    useValueChanged(
      isArmed,
      (_, _) => isArmed ? HapticFeedback.lightImpact() : null,
    );
    final scale = useValueSpring(isArmed ? 1 : 0.75, ratio: 0.5);

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: .symmetric(horizontal: sqrt(stretch)),
          width: _bubbleSize,
          height: _bubbleSize,
          decoration: ShapeDecoration(
            shape: const OvalBorder(),
            color: theme.colorScheme.surface.withValues(alpha: 0.25),
            shadows: [
              .new(
                color: Colors.black.withValues(alpha: 0.5 * percentArmed),
                blurStyle: .outer,
                blurRadius: 24 * percentArmed,
              ),
            ],
          ),
          clipBehavior: .antiAlias,
          child: BackdropFilter(
            filter: .compose(
              outer: .blur(sigmaX: 4, sigmaY: 4),
              inner: ColorFilter.matrix(_saturationMatrix(1.5)),
            ),
            child: Center(
              child: Text(
                entry.kanji,
                style: theme.textTheme.headlineLarge?.copyWith(height: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// dart format off
List<double> _saturationMatrix(double s) => [
  0.213*(1-s)+s, 0.715*(1-s)  , 0.072*(1-s)  , 0, 0,
  0.213*(1-s)  , 0.715*(1-s)+s, 0.072*(1-s)  , 0, 0,
  0.213*(1-s)  , 0.715*(1-s)  , 0.072*(1-s)+s, 0, 0,
  0            , 0            , 0            , 1, 0,
];
// dart format on
