import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class FlashcardAnimationState {
  FlashcardAnimationState({
    required this.dragOffset,
    required this.flipInProgress,
    required this.animationController,
    required this.animationStart,
    required this.animationEnd,
    required this.isAnimatingOut,
    required this.outgoingItem,
    required this.outgoingOffset,
    required this.hasCrossedThreshold,
  });

  final ValueNotifier<Offset> dragOffset;
  final ValueNotifier<bool> flipInProgress;
  final AnimationController animationController;
  final ValueNotifier<Offset> animationStart;
  final ValueNotifier<Offset> animationEnd;
  final ValueNotifier<bool> isAnimatingOut;
  final ValueNotifier<FlashcardItem?> outgoingItem;
  final ValueNotifier<Offset> outgoingOffset;
  final ValueNotifier<bool> hasCrossedThreshold;
}

FlashcardAnimationState useFlashcardAnimation() {
  final dragOffset = useState(Offset.zero);
  final flipInProgress = useState(false);

  final animationController = useUnboundedAnimationController();
  final animationStart = useState(Offset.zero);
  final animationEnd = useState(Offset.zero);
  final isAnimatingOut = useState(false);

  final outgoingItem = useState<FlashcardItem?>(null);
  final outgoingOffset = useState(Offset.zero);

  useEffect(() {
    void listener() {
      final value = Offset.lerp(
        animationStart.value,
        animationEnd.value,
        animationController.value,
      )!;
      if (isAnimatingOut.value) {
        outgoingOffset.value = value;
      } else {
        dragOffset.value = value;
      }
    }

    void statusListener(AnimationStatus status) {
      if (status == .completed && isAnimatingOut.value) {
        outgoingItem.value = null;
        outgoingOffset.value = .zero;
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

  return .new(
    dragOffset: dragOffset,
    flipInProgress: flipInProgress,
    animationController: animationController,
    animationStart: animationStart,
    animationEnd: animationEnd,
    isAnimatingOut: isAnimatingOut,
    outgoingItem: outgoingItem,
    outgoingOffset: outgoingOffset,
    hasCrossedThreshold: hasCrossedThreshold,
  );
}
