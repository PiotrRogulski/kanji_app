import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

enum FlashcardMode { kanji, words, mixed }

class FlashcardsScreen extends HookWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final kanjiData = context.watch<KanjiData>();

    final rangeStart = useState(kanjiData.entries.first.id);
    final rangeEnd = useState(kanjiData.entries.last.id);

    final selectedMode = useState(FlashcardMode.kanji);

    return Scaffold(
      appBar: AppBar(title: Text(s.flashcards_title)),
      body: AppPadding(
        padding: const .all(.large),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Text(s.flashcards_selectRange, style: theme.textTheme.titleMedium),
            AppUnit.small.gap,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: rangeStart.value.toString(),
                    keyboardType: .number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue != null) {
                        rangeStart.value = intValue;
                      }
                    },
                  ),
                ),
                AppUnit.small.gap,
                Expanded(
                  child: TextFormField(
                    initialValue: rangeEnd.value.toString(),
                    keyboardType: .number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                      if (intValue != null) {
                        rangeEnd.value = intValue;
                      }
                    },
                  ),
                ),
              ],
            ),
            AppUnit.large.gap,
            Text(s.flashcards_mode, style: theme.textTheme.titleMedium),
            AppUnit.small.gap,
            SegmentedButton<FlashcardMode>(
              segments: [
                .new(value: .kanji, label: Text(s.flashcards_modeKanji)),
                .new(value: .words, label: Text(s.flashcards_modeWords)),
                .new(value: .mixed, label: Text(s.flashcards_modeMixed)),
              ],
              selected: {selectedMode.value},
              onSelectionChanged: (newSelection) {
                selectedMode.value = newSelection.first;
              },
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => FlashcardsPlayRoute(
                startId: rangeStart.value,
                endId: rangeEnd.value,
                mode: selectedMode.value,
              ).go(context),
              child: Text(s.flashcards_start),
            ),
          ],
        ),
      ),
    );
  }
}
