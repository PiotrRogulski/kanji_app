import 'package:flutter/material.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_view.dart';

class NextFlashcards extends StatelessWidget {
  const NextFlashcards({
    super.key,
    required this.deck,
    required this.currentIndex,
    required this.dismissProgress,
    required this.flipInProgress,
  });

  final List<FlashcardItem> deck;
  final int currentIndex;
  final double dismissProgress;
  final bool flipInProgress;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(dismissProgress);

    final level2Dy = 10 * (1 - eased);
    final level2Scale = 0.95 + 0.05 * eased;

    final hasThird = currentIndex + 2 < deck.length;

    return Stack(
      children: [
        if (hasThird)
          Opacity(
            opacity: eased,
            child: Transform.translate(
              offset: const .new(0, 10),
              child: Transform.scale(
                scale: 0.95,
                alignment: .bottomCenter,
                child: FlashcardView(
                  key: ValueKey(deck[currentIndex + 2]),
                  item: deck[currentIndex + 2],
                  hideContent: flipInProgress,
                ),
              ),
            ),
          ),
        Transform.translate(
          offset: .new(0, level2Dy),
          child: Transform.scale(
            scale: level2Scale,
            alignment: .bottomCenter,
            child: FlashcardView(
              key: ValueKey(deck[currentIndex + 1]),
              item: deck[currentIndex + 1],
              hideContent: flipInProgress,
            ),
          ),
        ),
      ],
    );
  }
}
