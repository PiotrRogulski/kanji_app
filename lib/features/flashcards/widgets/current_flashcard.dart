import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/widgets/dismiss_indicator.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_view.dart';
import 'package:material_ui/material_ui.dart';

class const CurrentFlashcard({
  super.key,
  required final FlashcardItem item,
  required final Offset dragOffset,
  required final ValueChanged<bool> onFlipInProgressChange,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dismissProgress = dragOffset.dismissProgress;

    final t = Curves.easeOut.transform(dismissProgress);
    final angle = 0.06 * (dragOffset.dx / 200);
    final scale = 1.0 - 0.05 * t;
    final opacity = 1.0 - 0.1 * t;

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
              FlashcardDismissIndicator(dragOffset: dragOffset),
            ],
          ),
        ),
      ),
    );
  }
}
