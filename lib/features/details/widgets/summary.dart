import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/details/widgets/readings_group.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class KanjiSummary extends StatelessWidget {
  const KanjiSummary({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUnit.small,
        children: [
          Wrap(
            spacing: AppUnit.small,
            runSpacing: AppUnit.small,
            children: [
              KanjiTile(entry),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: AppUnit.small,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupedKanjiRow(
                    label: s.kanji_radical,
                    items: [entry.radical],
                  ),
                  KanjiReadingsGroup(entry),
                ],
              ),
            ],
          ),
          if (entry.synonyms.isNotEmpty)
            GroupedKanjiRow(label: s.kanji_synonyms, items: entry.synonyms),
          if (entry.antonyms.isNotEmpty)
            GroupedKanjiRow(label: s.kanji_antonyms, items: entry.antonyms),
        ],
      ),
    );
  }
}
