import 'dart:collection';

import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_view.dart';
import 'package:material_ui/material_ui.dart';

class const NextFlashcards({
  super.key,
  required final ListQueue<FlashcardItem> deck,
  required final int currentIndex,
  required final Offset dragOffset,
  required final bool flipInProgress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(dragOffset.dismissProgress);

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
                  key: ValueKey(deck.elementAt(currentIndex + 2)),
                  item: deck.elementAt(currentIndex + 2),
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
              key: ValueKey(deck.elementAt(currentIndex + 1)),
              item: deck.elementAt(currentIndex + 1),
              hideContent: flipInProgress,
            ),
          ),
        ),
      ],
    );
  }
}
