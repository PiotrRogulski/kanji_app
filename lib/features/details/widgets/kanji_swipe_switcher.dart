import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

const _bubbleSize = 64.0;
const _unarmedScale = 0.75;
const _triggerThreshold = 100.0;

class KanjiSwipeSwitcher extends HookWidget {
  const KanjiSwipeSwitcher({
    super.key,
    required this.entry,
    required this.child,
  });

  final KanjiEntry entry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final kanjiData = context.read<KanjiData>();

    final previousEntry = kanjiData.get(entry.id - 1);
    final nextEntry = kanjiData.get(entry.id + 1);

    final tickerProvider = useSingleTickerProvider();
    final dragOffsetController = useDisposable(
      builder: () => AnimationController.unbounded(vsync: tickerProvider),
      dispose: (controller) => controller.dispose(),
      keys: [tickerProvider],
    );

    void onDragEnd() {
      if (dragOffsetController.value > _triggerThreshold &&
          previousEntry != null) {
        KanjiDetailsRoute(previousEntry.id).go(context);
      } else if (dragOffsetController.value < -_triggerThreshold &&
          nextEntry != null) {
        KanjiDetailsRoute(nextEntry.id).go(context);
      }
      dragOffsetController.animateWith(
        SpringSimulation(
          SpringDescription.withDurationAndBounce(duration: Durations.medium1),
          dragOffsetController.value,
          0,
          1,
        ),
      );
    }

    final offset = useListenableSelector(
      dragOffsetController,
      () => dragOffsetController.value,
    );

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        dragOffsetController.value += details.delta.dx / 2;
      },
      onHorizontalDragCancel: onDragEnd,
      onHorizontalDragEnd: (_) => onDragEnd(),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          ?switch (offset) {
            > 0 when previousEntry != null => Positioned(
              top: 0,
              bottom: 0,
              left: min(offset, _triggerThreshold) - _bubbleSize,
              child: _KanjiPreviewBubble(previousEntry, offset: offset),
            ),
            < 0 when nextEntry != null => Positioned(
              top: 0,
              bottom: 0,
              right: min(-offset, _triggerThreshold) - _bubbleSize,
              child: _KanjiPreviewBubble(nextEntry, offset: -offset),
            ),
            _ => null,
          },
        ],
      ),
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

    final tickerProvider = useSingleTickerProvider();
    final scaleController = useDisposable(
      builder: () => AnimationController.unbounded(
        vsync: tickerProvider,
        value: _unarmedScale,
      ),
      dispose: (controller) => controller.dispose(),
      keys: [tickerProvider],
    );

    useValueChanged<bool, void>(percentArmed == 1, (_, _) {
      if (percentArmed == 1) {
        scaleController.animateWith(
          SpringSimulation(
            SpringDescription.withDurationAndBounce(
              duration: Durations.medium4,
              bounce: 0.75,
            ),
            scaleController.value,
            1,
            1,
          ),
        );
      } else {
        scaleController.animateWith(
          SpringSimulation(
            SpringDescription.withDurationAndBounce(
              duration: Durations.medium4,
              bounce: 0.5,
            ),
            scaleController.value,
            _unarmedScale,
            1,
          ),
        );
      }
    });

    return Center(
      child: ScaleTransition(
        scale: scaleController,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: sqrt(stretch)),
          width: _bubbleSize,
          height: _bubbleSize,
          decoration: ShapeDecoration(
            shape: const OvalBorder(),
            color: theme.colorScheme.surface.withValues(alpha: 0.25),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5 * percentArmed),
                blurStyle: BlurStyle.outer,
                blurRadius: 24 * percentArmed,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.compose(
              outer: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
