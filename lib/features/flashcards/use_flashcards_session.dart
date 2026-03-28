import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class FlashcardsSession {
  FlashcardsSession._({
    required this.totalCount,
    required this.deck,
    required this.learnedCount,
    required this._revision,
  });

  final int totalCount;
  final ListQueue<FlashcardItem> deck;
  final ValueNotifier<int> learnedCount;
  final ValueNotifier<int> _revision;

  bool get isFinished => deck.isEmpty;

  FlashcardItem get current => deck.first;

  int get progressIndex =>
      (learnedCount.value + 1).clamp(1, totalCount == 0 ? 1 : totalCount);

  String get progressText => '$progressIndex / $totalCount';

  void dismiss(FlashcardDismissAction action) {
    if (deck.isEmpty) {
      return;
    }

    final item = deck.removeFirst();

    if (action == .skipped) {
      deck.add(item);
    } else {
      learnedCount.value++;
    }

    _revision.value++;
  }
}

FlashcardsSession useFlashcardsSession(List<FlashcardItem> initialDeck) {
  final deck = useMemoized(() => ListQueue.of(initialDeck), [initialDeck]);
  final learnedCount = useState(0);
  final revision = useState(0);

  useEffect(() {
    learnedCount.value = 0;
    deck
      ..clear()
      ..addAll(initialDeck);
    revision.value++;

    return null;
  }, [initialDeck]);

  return ._(
    totalCount: initialDeck.length,
    deck: deck,
    learnedCount: learnedCount,
    revision: revision,
  );
}
