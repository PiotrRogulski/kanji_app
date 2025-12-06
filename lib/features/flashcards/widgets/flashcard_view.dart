import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class FlashcardView extends HookWidget {
  const FlashcardView({
    super.key,
    required this.item,
    this.onFlipInProgressChange,
    this.hideContent = false,
  });

  final FlashcardItem item;
  final ValueChanged<bool>? onFlipInProgressChange;
  final bool hideContent;

  @override
  Widget build(BuildContext context) {
    final controller = useUnboundedAnimationController();
    final isFlipped = useState(false);

    useEffect(() {
      if (onFlipInProgressChange == null) {
        return null;
      }

      void listener(AnimationStatus status) {
        onFlipInProgressChange!.call(status == .forward || status == .reverse);
      }

      controller.addStatusListener(listener);

      return () => controller.removeStatusListener(listener);
    }, [controller, onFlipInProgressChange]);

    return GestureDetector(
      onTap: () {
        final spring = SpringDescription.withDampingRatio(
          mass: 1,
          stiffness: 300,
          ratio: 0.8,
        );
        if (isFlipped.value) {
          controller.animateWith(
            SpringSimulation(spring, controller.value, 0, 0, snapToEnd: true),
          );
        } else {
          controller.animateWith(
            SpringSimulation(spring, controller.value, 1, 0, snapToEnd: true),
          );
        }
        isFlipped.value = !isFlipped.value;
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * pi;
          final isBackVisible = controller.value >= 0.5;

          var transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          if (isBackVisible) {
            transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle + pi);
          }

          return Transform(
            transform: transform,
            alignment: .center,
            child: isBackVisible
                ? _buildSide(context, isFront: false)
                : _buildSide(context, isFront: true),
          );
        },
      ),
    );
  }

  Widget _buildSide(BuildContext context, {required bool isFront}) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth.clamp(280.0, 600.0);
        final cardHeight = constraints.maxHeight.clamp(260.0, 1600.0);

        return Center(
          child: Card(
            key: ValueKey(isFront),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.circular(.large),
            ),
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: AppPadding(
                padding: const .all(.xlarge),
                child: Opacity(
                  opacity: hideContent ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    mainAxisAlignment: .center,
                    children: [
                      if (isFront)
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                item.frontText,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: item.type == .kanji ? 140 : 80,
                                ),
                                textAlign: .center,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        Center(
                          child: Text(
                            item.backText,
                            style: theme.textTheme.headlineLarge,
                            textAlign: .center,
                          ),
                        ),
                        AppUnit.medium.gap,
                        if (item.subTextBack case final subTextBack?)
                          Text(
                            subTextBack,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: .center,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
