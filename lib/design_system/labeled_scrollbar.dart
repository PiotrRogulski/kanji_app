import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/motion.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const LabeledScrollbar({
  super.key,
  required final ScrollController controller,
  required final Widget label,
  required final Widget child,
}) extends HookWidget {
  static const _minThumbExtent = 48.0;

  static const _grabWidth = 40.0;

  static const _bubbleSize = 96.0;

  static const _fastLag = 32.0;

  static final _slowShape = MaterialShapeBorder(
    shape: MaterialShapes.cookie9Sided,
  );
  static final _fastShape = MaterialShapeBorder(
    shape: MaterialShapes.softBurst,
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewPadding = MediaQuery.viewPaddingOf(context);

    final scroll = useState((extent: 0.0, offset: 0.0));
    final scrollExtent = scroll.value.extent;
    final scrolled = scrollExtent > 0
        ? clampDouble(scroll.value.offset / scrollExtent, 0, 1)
        : 0.0;

    final dragging = useState(false);
    final draggedByTouch = useState(false);
    final popped = max<double>(
      useValueSpring(
        dragging.value ? 1 : 0,
        spring: Springs.expressiveFastSpatial,
        snapToEnd: true,
      ),
      0,
    );

    final follower = useUnboundedAnimationController(initialValue: scrolled);
    useValueChanged<double, void>(scrolled, (_, _) {
      follower.springTo(
        scrolled,
        spring: Springs.expressiveFastSpatial,
        velocity: follower.velocity,
      );
    });
    final followed = useAnimation(follower);

    return NotificationListener(
      onNotification: (notification) {
        if (notification
            case ScrollMetricsNotification(depth: 0, :final metrics) ||
                ScrollUpdateNotification(depth: 0, :final metrics)) {
          scroll.value = (
            extent: metrics.maxScrollExtent,
            offset: metrics.pixels,
          );
        }
        return false;
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final trackStart = viewPadding.top + AppUnit.large;
            final trackExtent =
                constraints.maxHeight -
                trackStart -
                viewPadding.bottom -
                AppUnit.large;
            final thumbExtent = max(
              _minThumbExtent,
              trackExtent *
                  constraints.maxHeight /
                  (constraints.maxHeight + scrollExtent),
            );
            final thumbTravel = trackExtent - thumbExtent;
            final scrollable = scrollExtent > 0 && thumbTravel > 0;

            final bubbleCenter =
                trackStart + thumbExtent / 2 + thumbTravel * followed;
            final lag = thumbTravel * (scrolled - followed);

            return Stack(
              children: [
                child,
                if (scrollable)
                  PositionedDirectional(
                    top: trackStart + thumbTravel * scrolled,
                    end: 0,
                    width: _grabWidth,
                    height: thumbExtent,
                    child: GestureDetector(
                      behavior: .opaque,
                      onVerticalDragStart: (details) {
                        HapticFeedback.lightImpact();
                        draggedByTouch.value = details.kind == .touch;
                        dragging.value = true;
                      },
                      onVerticalDragUpdate: (details) => controller.jumpTo(
                        clampDouble(
                          controller.offset +
                              details.delta.dy * scrollExtent / thumbTravel,
                          0,
                          scrollExtent,
                        ),
                      ),
                      onVerticalDragEnd: (_) => dragging.value = false,
                      onVerticalDragCancel: () => dragging.value = false,
                      child: Align(
                        alignment: .centerEnd,
                        child: Container(
                          width: AppUnit.xsmall * (1 + 2 * popped),
                          height: .infinity,
                          margin: const AppEdgeInsets.only(end: .xsmall),
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: .lerp(
                              colorScheme.outline,
                              colorScheme.primary,
                              min(popped, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (scrollable && popped > 0)
                  PositionedDirectional(
                    top: bubbleCenter - _bubbleSize / 2,
                    end: AppUnit.large * (draggedByTouch.value ? 3 : 1),
                    width: _bubbleSize,
                    height: _bubbleSize,
                    child: Transform.scale(
                      scale: popped,
                      alignment: .centerEnd,
                      child: Stack(
                        alignment: .center,
                        children: [
                          Positioned.fill(
                            child: Transform.rotate(
                              angle: -bubbleCenter / (_bubbleSize / 2),
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: colorScheme.primary,
                                  shape: .lerp(
                                    _slowShape,
                                    _fastShape,
                                    min(lag.abs() / _fastLag, 1),
                                  )!,
                                ),
                              ),
                            ),
                          ),
                          label,
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
