import 'package:flutter/material.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/widgets/dismiss_indicator.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_view.dart';

class CurrentFlashcard extends StatelessWidget {
  const CurrentFlashcard({
    super.key,
    required this.item,
    required this.dragOffset,
    required this.dismissProgress,
    required this.onFlipInProgressChange,
  });

  final FlashcardItem item;
  final Offset dragOffset;
  final double dismissProgress;
  final ValueChanged<bool> onFlipInProgressChange;

  @override
  Widget build(BuildContext context) {
    final t = Curves.easeOut.transform(dismissProgress);
    final angle = 0.06 * (dragOffset.dx / 200);
    final scale = 1.0 - 0.05 * t;
    final opacity = 1.0 - 0.25 * t;

    return Transform.translate(
      offset: dragOffset,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: Stack(
            alignment: .center,
            children: [
              Opacity(
                opacity: opacity,
                child: FlashcardView(
                  key: ValueKey(item),
                  item: item,
                  onFlipInProgressChange: onFlipInProgressChange,
                ),
              ),
              FlashcardDismissIndicator(dismissProgress: dismissProgress),
            ],
          ),
        ),
      ),
    );
  }
}
