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

    final startController = useTextEditingController(
      text: rangeStart.value.toString(),
    );
    final endController = useTextEditingController(
      text: rangeEnd.value.toString(),
    );

    final selectedMode = useState(FlashcardMode.kanji);

    final scrollController = useScrollController();

    final isValid = rangeStart.value <= rangeEnd.value;

    return AppBigTitleScaffold(
      title: s.flashcards_title,
      scrollController: scrollController,
      showScrollToTopFab: false,
      bottomChild: FilledButton(
        onPressed: isValid
            ? () => FlashcardsPlayRoute(
                startId: rangeStart.value,
                endId: rangeEnd.value,
                mode: selectedMode.value,
              ).go(context)
            : null,
        child: Text(s.flashcards_start),
      ),
      slivers: [
        AppUnit.medium.sliverGap,
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                s.flashcards_selectRange,
                style: theme.textTheme.titleMedium,
              ),
              AppUnit.small.gap,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: startController,
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
                      controller: endController,
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
              AppConnectedButtonGroup<FlashcardMode>(
                segments: [
                  .new(value: .kanji, label: s.flashcards_modeKanji),
                  .new(value: .words, label: s.flashcards_modeWords),
                  .new(value: .mixed, label: s.flashcards_modeMixed),
                ],
                selected: selectedMode.value,
                onSelectionChanged: (value) => selectedMode.value = value,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
