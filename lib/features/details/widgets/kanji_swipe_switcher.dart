import 'dart:math';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
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

    final dragging = useState(false);

    final rawDragOffset = useState<double>(0);
    final dragOffset = useValueSpring(
      rawDragOffset.value,
      spring: Springs.expressiveFastSpatial,
      animate: !dragging.value,
    );

    void onDragEnd() {
      dragging.value = false;
      if (rawDragOffset.value > _triggerThreshold && previousEntry != null) {
        KanjiDetailsRoute(previousEntry.id).go(context);
      } else if (rawDragOffset.value < -_triggerThreshold &&
          nextEntry != null) {
        KanjiDetailsRoute(nextEntry.id).go(context);
      }
      rawDragOffset.value = 0;
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        dragging.value = true;
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

class const _PositionedKanjiPreview(final KanjiEntry entry, final double offset)
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final absOffset = offset.abs();
    final percentArmed = (absOffset / _triggerThreshold).clamp(0, 1);
    final stretch = max(0, absOffset - _triggerThreshold);
    final isArmed = percentArmed == 1;

    final scale = useValueSpring(
      isArmed ? 2 : 1,
      spring: Springs.expressiveFastSpatial,
    );

    return Positioned.directional(
      textDirection: offset > 0 ? .ltr : .rtl,
      top: 0,
      bottom: 0,
      start:
          min(offset.abs(), _triggerThreshold) -
          _bubbleSize -
          (scale - 1) * _bubbleSize / 2,
      child: _KanjiPreviewBubble(
        entry,
        percentArmed: percentArmed.toDouble(),
        stretch: stretch.toDouble(),
        scale: scale,
      ),
    );
  }
}

class const _KanjiPreviewBubble(
  final KanjiEntry entry, {
  required final double percentArmed,
  required final double stretch,
  required final double scale,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: .symmetric(horizontal: sqrt(stretch)),
        width: _bubbleSize * scale,
        height: _bubbleSize * scale,
        child: LiquidGlass.auto(
          shape: const LiquidOval(),
          settings: appLiquidGlassSettings,
          appearance: appLiquidGlassAppearance.copyWith(
            tint: theme.colorScheme.surface.withValues(alpha: 0.25),
          ),
          child: Center(
            child: Text(
              entry.kanji,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(height: 1)
                  .apply(fontSizeFactor: scale),
            ),
          ),
        ),
      ),
    );
  }
}
