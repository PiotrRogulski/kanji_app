import 'package:kanji_app/features/flashcards/flashcard_item.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

List<FlashcardItem> useDeck({
  required int startId,
  required int endId,
  required FlashcardMode mode,
}) {
  final context = useContext();
  final kanjiData = context.watch<KanjiData>();

  return useMemoized(
    () => [
      for (final entry in kanjiData.entries)
        if (entry.id >= startId && entry.id <= endId) ...[
          if (mode case .kanji || .mixed)
            .new(
              frontText: entry.kanji,
              backText: entry.readings.join('\n'),
              type: .kanji,
            ),
          if (mode case .words || .mixed)
            for (final word in entry.wordsRequiredNow)
              .new(
                frontText: word.kanji.isNotEmpty ? word.kanji : word.reading,
                backText: word.meaning,
                subTextBack: word.reading,
                type: .word,
              ),
        ],
    ]..shuffle(),
    [startId, endId, mode, kanjiData],
  );
}
