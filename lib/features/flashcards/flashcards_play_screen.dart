import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/flashcards/use_deck.dart';
import 'package:kanji_app/features/flashcards/use_flashcard_animation.dart';
import 'package:kanji_app/features/flashcards/widgets/current_flashcard.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_gestures.dart';
import 'package:kanji_app/features/flashcards/widgets/next_flashcards.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

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

    final animationState = useFlashcardAnimation();

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
                        min(
                          animationState.dragOffset.value.distance,
                          dismissDistance,
                        ) /
                        dismissDistance,
                    flipInProgress: animationState.flipInProgress.value,
                  ),
                ),
              FlashcardGestures(
                animationState: animationState,
                currentIndex: currentIndex,
                deck: deck,
                child: CurrentFlashcard(
                  item: deck[currentIndex.value],
                  dragOffset: animationState.dragOffset.value,
                  dismissProgress:
                      min(
                        animationState.dragOffset.value.distance,
                        dismissDistance,
                      ) /
                      dismissDistance,
                  onFlipInProgressChange: (value) =>
                      animationState.flipInProgress.value = value,
                ),
              ),
              if (animationState.outgoingItem.value case final outgoing?)
                IgnorePointer(
                  child: Opacity(
                    opacity:
                        (1 -
                                (animationState.outgoingOffset.value -
                                            animationState.animationStart.value)
                                        .distance /
                                    dismissDistance)
                            .clamp(0.0, 1.0),
                    child: CurrentFlashcard(
                      item: outgoing,
                      dragOffset: animationState.outgoingOffset.value,
                      dismissProgress:
                          min(
                            animationState.outgoingOffset.value.distance,
                            dismissDistance,
                          ) /
                          dismissDistance,
                      onFlipInProgressChange: (_) {},
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
