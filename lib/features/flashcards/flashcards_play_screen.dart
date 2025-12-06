import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/flashcards/use_deck.dart';
import 'package:kanji_app/features/flashcards/widgets/current_flashcard.dart';
import 'package:kanji_app/features/flashcards/widgets/next_flashcards.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

const _dismissDistance = 200.0;
const _minVelocity = 800.0;
final _spring = SpringDescription.withDampingRatio(
  mass: 1,
  stiffness: 800,
  ratio: 0.5,
);

class FlashcardsPlayScreen extends HookWidget {
  const FlashcardsPlayScreen({
    super.key,
    required this.startId,
    required this.endId,
    required this.mode,
  });

  final int startId;
  final int endId;
  final FlashcardMode mode;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final deck = useDeck(startId: startId, endId: endId, mode: mode);

    final currentIndex = useState(0);
    final dragOffset = useState(Offset.zero);
    final flipInProgress = useState(false);

    final animationController = useUnboundedAnimationController();
    final animationStart = useState(Offset.zero);
    final animationEnd = useState(Offset.zero);
    final isAnimatingOut = useState(false);

    useEffect(() {
      void listener() {
        dragOffset.value = .lerp(
          animationStart.value,
          animationEnd.value,
          animationController.value,
        )!;
      }

      void statusListener(AnimationStatus status) {
        if (status == .completed && isAnimatingOut.value) {
          currentIndex.value++;
          dragOffset.value = .zero;
          isAnimatingOut.value = false;
        }
      }

      animationController
        ..addListener(listener)
        ..addStatusListener(statusListener);

      return () {
        animationController
          ..removeListener(listener)
          ..removeStatusListener(statusListener);
      };
    }, [animationController, animationStart.value, animationEnd.value]);

    final hasCrossedThreshold = useState(false);

    if (deck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(s.flashcards_title)),
        body: Center(child: Text(s.flashcards_emptyDeck)),
      );
    }

    if (currentIndex.value >= deck.length) {
      return Scaffold(
        appBar: AppBar(title: Text(s.flashcards_title)),
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                s.flashcards_end,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              AppUnit.large.gap,
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(s.common_back),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentIndex.value + 1} / ${deck.length}'),
        centerTitle: true,
      ),
      body: AppPadding(
        padding: const .all(.large),
        child: Center(
          child: Stack(
            children: [
              if (currentIndex.value + 1 < deck.length)
                IgnorePointer(
                  child: NextFlashcards(
                    deck: deck,
                    currentIndex: currentIndex.value,
                    dismissProgress:
                        min(dragOffset.value.distance, _dismissDistance) /
                        _dismissDistance,
                    flipInProgress: flipInProgress.value,
                  ),
                ),
              FlashcardGestures(
                animationController: animationController,
                dragOffset: dragOffset,
                flipInProgress: flipInProgress,
                isAnimatingOut: isAnimatingOut,
                hasCrossedThreshold: hasCrossedThreshold,
                animationStart: animationStart,
                animationEnd: animationEnd,
                child: CurrentFlashcard(
                  item: deck[currentIndex.value],
                  dragOffset: dragOffset.value,
                  dismissProgress:
                      min(dragOffset.value.distance, _dismissDistance) /
                      _dismissDistance,
                  onFlipInProgressChange: (value) =>
                      flipInProgress.value = value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashcardGestures extends StatelessWidget {
  const FlashcardGestures({
    super.key,
    required this.animationController,
    required this.dragOffset,
    required this.flipInProgress,
    required this.isAnimatingOut,
    required this.hasCrossedThreshold,
    required this.animationStart,
    required this.animationEnd,
    required this.child,
  });

  final AnimationController animationController;
  final ValueNotifier<Offset> dragOffset;
  final ValueNotifier<bool> flipInProgress;
  final ValueNotifier<bool> isAnimatingOut;
  final ValueNotifier<bool> hasCrossedThreshold;
  final ValueNotifier<Offset> animationStart;
  final ValueNotifier<Offset> animationEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    void onPanStart(DragStartDetails details) {
      if (flipInProgress.value) {
        return;
      }
      animationController.stop();
      isAnimatingOut.value = false;
      hasCrossedThreshold.value = false;
    }

    void onPanUpdate(DragUpdateDetails details) {
      if (flipInProgress.value) {
        return;
      }
      dragOffset.value += details.delta;

      final distanceNow = dragOffset.value.distance;
      final crossed = distanceNow > _dismissDistance;
      if (crossed != hasCrossedThreshold.value) {
        hasCrossedThreshold.value = crossed;
        HapticFeedback.lightImpact();
      }
    }

    void onPanEnd(DragEndDetails details) {
      final velocity = details.velocity.pixelsPerSecond;
      final distance = dragOffset.value.distance;
      final velocityMagnitude = velocity.distance;

      final shouldDismiss =
          distance > _dismissDistance || velocityMagnitude > _minVelocity;

      if (shouldDismiss) {
        final Offset direction;
        if (velocityMagnitude > _minVelocity) {
          direction = velocity / velocityMagnitude;
        } else if (distance > 0) {
          direction = dragOffset.value / distance;
        } else {
          direction = const Offset(1, 0);
        }

        animationStart.value = dragOffset.value;
        animationEnd.value = dragOffset.value + direction * 800.0;
        isAnimatingOut.value = true;
        final path = animationEnd.value - animationStart.value;
        final pathLen = path.distance;
        double initialVelocityT = 0;
        if (pathLen > 0) {
          final dir = path / pathLen;
          initialVelocityT =
              (velocity.dx * dir.dx + velocity.dy * dir.dy) / pathLen;
        }
        animationController.value = 0;
        animationController.animateWith(
          SpringSimulation(_spring, 0, 1, initialVelocityT),
        );
      } else {
        animationStart.value = dragOffset.value;
        animationEnd.value = .zero;
        isAnimatingOut.value = false;
        final path = animationEnd.value - animationStart.value;
        final pathLen = path.distance;
        double initialVelocityT = 0;
        if (pathLen > 0) {
          final dir = path / pathLen;
          initialVelocityT =
              (velocity.dx * dir.dx + velocity.dy * dir.dy) / pathLen;
        }
        animationController.value = 0;
        animationController.animateWith(
          SpringSimulation(_spring, 0, 1, initialVelocityT),
        );
      }

      hasCrossedThreshold.value = false;
    }

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: child,
    );
  }
}
