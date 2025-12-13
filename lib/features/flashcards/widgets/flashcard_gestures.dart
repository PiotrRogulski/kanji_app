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
    required this.deck,
    required this.onDismissed,
    required this.child,
  });

  final FlashcardAnimationState animationState;
  final List<FlashcardItem> deck;
  final ValueChanged<FlashcardDismissAction> onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final handler = _FlashcardPanHandler(
      animationState: animationState,
      deck: deck,
      onDismissed: onDismissed,
    );

    return GestureDetector(
      onPanStart: handler.onPanStart,
      onPanUpdate: handler.onPanUpdate,
      onPanEnd: handler.onPanEnd,
      child: child,
    );
  }
}

class _FlashcardPanHandler {
  _FlashcardPanHandler({
    required this.animationState,
    required this.deck,
    required this.onDismissed,
  });

  final FlashcardAnimationState animationState;
  final List<FlashcardItem> deck;
  final ValueChanged<FlashcardDismissAction> onDismissed;

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
    if (deck.isEmpty) {
      animationState.hasCrossedThreshold.value = false;
      return;
    }

    final velocity = details.velocity.pixelsPerSecond;
    final distance = animationState.dragOffset.value.distance;
    final velocityMagnitude = velocity.distance;

    final shouldDismiss =
        distance > dismissDistance || velocityMagnitude > minVelocity;

    if (shouldDismiss) {
      final direction = _dismissDirection(
        velocity: velocity,
        velocityMagnitude: velocityMagnitude,
        distance: distance,
        dragOffset: animationState.dragOffset.value,
      );

      _animateOut(details: details, direction: direction);
      animationState.dragOffset.value = .zero;

      onDismissed(direction.dx >= 0 ? .learned : .skipped);
    } else {
      _animateBack(details: details);
    }

    animationState.hasCrossedThreshold.value = false;
  }

  Offset _dismissDirection({
    required Offset velocity,
    required double velocityMagnitude,
    required double distance,
    required Offset dragOffset,
  }) {
    if (velocityMagnitude > minVelocity) {
      return velocity / velocityMagnitude;
    }
    if (distance > 0) {
      return dragOffset / distance;
    }
    return const Offset(1, 0);
  }

  void _animateOut({
    required DragEndDetails details,
    required Offset direction,
  }) {
    final velocity = details.velocity.pixelsPerSecond;

    animationState.animationStart.value = animationState.dragOffset.value;
    animationState.animationEnd.value =
        animationState.dragOffset.value + direction * 800.0;
    animationState.isAnimatingOut.value = true;
    animationState.outgoingItem.value = deck.first;
    animationState.outgoingOffset.value = animationState.animationStart.value;

    _animateSpring(velocity: velocity);
  }

  void _animateBack({required DragEndDetails details}) {
    final velocity = details.velocity.pixelsPerSecond;

    animationState.animationStart.value = animationState.dragOffset.value;
    animationState.animationEnd.value = .zero;
    animationState.isAnimatingOut.value = false;

    _animateSpring(velocity: velocity);
  }

  void _animateSpring({required Offset velocity}) {
    final path =
        animationState.animationEnd.value - animationState.animationStart.value;
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
}
