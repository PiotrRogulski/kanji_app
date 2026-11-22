import 'dart:math';

import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

const _bubbleSize = 48.0;
const _triggerThreshold = 100.0;

class const KanjiSwipeSwitcher({super.key, required final Widget child})
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final kanjiData = context.read<KanjiData>();
    final entry = context.watch<KanjiEntry>();

    final previousEntry = kanjiData.get(entry.id - 1);
    final nextEntry = kanjiData.get(entry.id + 1);

    final dragOffset = useState<double>(0);

    void onDragEnd() {
      if (dragOffset.value > _triggerThreshold && previousEntry != null) {
        KanjiDetailsRoute(previousEntry.id).go(context);
      } else if (dragOffset.value < -_triggerThreshold && nextEntry != null) {
        KanjiDetailsRoute(nextEntry.id).go(context);
      }
      dragOffset.value = 0;
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        dragOffset.value += details.delta.dx;
      },
      onHorizontalDragCancel: onDragEnd,
      onHorizontalDragEnd: (_) => onDragEnd(),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          if (previousEntry != null && dragOffset.value > 0)
            _PositionedKanjiPreview(previousEntry, dragOffset.value),
          if (nextEntry != null && dragOffset.value < 0)
            _PositionedKanjiPreview(nextEntry, dragOffset.value),
        ],
      ),
    );
  }
}

class const _PositionedKanjiPreview(final KanjiEntry entry, final double offset)
    extends StatelessWidget {
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

// https://github.com/dart-lang/sdk/issues/64037
// ignore: prefer_const_constructors_in_immutables
class _KanjiPreviewBubble(final KanjiEntry entry, {required double offset})
    extends HookWidget {
  final double percentArmed = (offset / _triggerThreshold).clamp(0, 1);
  final double stretch = max(0, offset - _triggerThreshold);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isArmed = percentArmed == 1;
    useValueChanged(
      isArmed,
      (_, _) => isArmed ? HapticFeedback.lightImpact() : null,
    );
    final scale = useValueSpring(
      isArmed ? 1.5 : 1,
      spring: Springs.expressiveFastSpatial,
    );

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
                style: theme.textTheme.headlineMedium?.copyWith(height: 1),
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
