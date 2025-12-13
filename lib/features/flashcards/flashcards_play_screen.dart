import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/flashcards/use_deck.dart';
import 'package:kanji_app/features/flashcards/use_flashcard_animation.dart';
import 'package:kanji_app/features/flashcards/use_flashcards_session.dart';
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

    final initialDeck = useDeck(startId: startId, endId: endId, mode: mode);
    final session = useFlashcardsSession(initialDeck);

    if (initialDeck.isEmpty) {
      return _FlashcardsEmptyScaffold(
        title: s.flashcards_title,
        message: s.flashcards_emptyDeck,
      );
    }

    if (session.isFinished) {
      return _FlashcardsEndScaffold(
        title: s.flashcards_title,
        endText: s.flashcards_end,
        backText: s.common_back,
        onBack: () => Navigator.of(context).pop(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(session.progressText), centerTitle: true),
      body: _FlashcardsPlayBody(session: session),
    );
  }
}

class _FlashcardsPlayBody extends HookWidget {
  const _FlashcardsPlayBody({required this.session});

  final FlashcardsSession session;

  @override
  Widget build(BuildContext context) {
    final animationState = useFlashcardAnimation();

    return AppPadding(
      padding: const .all(.large),
      child: Center(
        child: Stack(
          children: [
            if (session.deck.length >= 2)
              IgnorePointer(
                child: NextFlashcards(
                  deck: session.deck,
                  currentIndex: 0,
                  dragOffset: animationState.dragOffset.value,
                  flipInProgress: animationState.flipInProgress.value,
                ),
              ),
            FlashcardGestures(
              animationState: animationState,
              deck: session.deck,
              onDismissed: session.dismiss,
              child: CurrentFlashcard(
                item: session.current,
                dragOffset: animationState.dragOffset.value,
                onFlipInProgressChange: (value) =>
                    animationState.flipInProgress.value = value,
              ),
            ),
            if (animationState.outgoingItem.value case final outgoing?)
              IgnorePointer(
                child: Opacity(
                  opacity: animationState.outgoingOpacity,
                  child: CurrentFlashcard(
                    item: outgoing,
                    dragOffset: animationState.outgoingOffset.value,
                    onFlipInProgressChange: (_) {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FlashcardsEmptyScaffold extends StatelessWidget {
  const _FlashcardsEmptyScaffold({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message)),
    );
  }
}

class _FlashcardsEndScaffold extends StatelessWidget {
  const _FlashcardsEndScaffold({
    required this.title,
    required this.endText,
    required this.backText,
    required this.onBack,
  });

  final String title;
  final String endText;
  final String backText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(endText, style: Theme.of(context).textTheme.headlineMedium),
            AppUnit.large.gap,
            FilledButton(onPressed: onBack, child: Text(backText)),
          ],
        ),
      ),
    );
  }
}
