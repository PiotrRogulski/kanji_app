import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/use_flashcard_animation.dart';

class FlashcardGestures extends StatelessWidget {
  const FlashcardGestures({
    super.key,
    required this.animationState,
    required this.currentIndex,
    required this.deck,
    required this.child,
  });

  final FlashcardAnimationState animationState;
  final ValueNotifier<int> currentIndex;
  final List<FlashcardItem> deck;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    void onPanStart(DragStartDetails details) {
      if (animationState.flipInProgress.value) {
        return;
      }
      if (!animationState.isAnimatingOut.value) {
        animationState.animationController.stop();
      }
      animationState.hasCrossedThreshold.value = false;
    }

    void onPanUpdate(DragUpdateDetails details) {
      if (animationState.flipInProgress.value) {
        return;
      }
      animationState.dragOffset.value += details.delta;

      final distanceNow = animationState.dragOffset.value.distance;
      final crossed = distanceNow > dismissDistance;
      if (crossed != animationState.hasCrossedThreshold.value) {
        animationState.hasCrossedThreshold.value = crossed;
        HapticFeedback.lightImpact();
      }
    }

    void onPanEnd(DragEndDetails details) {
      final velocity = details.velocity.pixelsPerSecond;
      final distance = animationState.dragOffset.value.distance;
      final velocityMagnitude = velocity.distance;

      final shouldDismiss =
          distance > dismissDistance || velocityMagnitude > minVelocity;

      if (shouldDismiss) {
        final Offset direction;
        if (velocityMagnitude > minVelocity) {
          direction = velocity / velocityMagnitude;
        } else if (distance > 0) {
          direction = animationState.dragOffset.value / distance;
        } else {
          direction = const Offset(1, 0);
        }

        animationState.animationStart.value = animationState.dragOffset.value;
        animationState.animationEnd.value =
            animationState.dragOffset.value + direction * 800.0;
        animationState.isAnimatingOut.value = true;
        animationState.outgoingItem.value = deck[currentIndex.value];
        animationState.outgoingOffset.value =
            animationState.animationStart.value;
        final path =
            animationState.animationEnd.value -
            animationState.animationStart.value;
        final pathLen = path.distance;
        double initialVelocityT = 0;
        if (pathLen > 0) {
          final dir = path / pathLen;
          initialVelocityT =
              (velocity.dx * dir.dx + velocity.dy * dir.dy) / pathLen;
        }
        animationState.animationController.value = 0;
        animationState.animationController.animateWith(
          SpringSimulation(spring, 0, 1, initialVelocityT),
        );

        animationState.dragOffset.value = .zero;
        currentIndex.value++;
      } else {
        animationState.animationStart.value = animationState.dragOffset.value;
        animationState.animationEnd.value = .zero;
        animationState.isAnimatingOut.value = false;
        final path =
            animationState.animationEnd.value -
            animationState.animationStart.value;
        final pathLen = path.distance;
        double initialVelocityT = 0;
        if (pathLen > 0) {
          final dir = path / pathLen;
          initialVelocityT =
              (velocity.dx * dir.dx + velocity.dy * dir.dy) / pathLen;
        }
        animationState.animationController.value = 0;
        animationState.animationController.animateWith(
          SpringSimulation(spring, 0, 1, initialVelocityT),
        );
      }

      animationState.hasCrossedThreshold.value = false;
    }

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: child,
    );
  }
}
