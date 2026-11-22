import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class FlashcardAnimationState({
  required final ValueNotifier<Offset> dragOffset,
  required final ValueNotifier<bool> flipInProgress,
  required final AnimationController animationController,
  required final ValueNotifier<Offset> animationStart,
  required final ValueNotifier<Offset> animationEnd,
  required final ValueNotifier<bool> isAnimatingOut,
  required final ValueNotifier<FlashcardItem?> outgoingItem,
  required final ValueNotifier<Offset> outgoingOffset,
  required final ValueNotifier<bool> hasCrossedThreshold,
}) {
  double get outgoingOpacity =>
      1 -
      (outgoingOffset.value - animationStart.value).dismissProgress.clamp(0, 1);
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
