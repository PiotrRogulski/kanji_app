import 'package:flutter/material.dart';
import 'package:kanji_app/design_system/card.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/widgets/readings.dart';

class KanjiReadingsGroup extends StatelessWidget {
  const KanjiReadingsGroup(this.kanji, {super.key});

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('Czytania', style: theme.textTheme.bodyLarge),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kanji.readings.onyomi.isNotEmpty)
                  KanjiReadings(kanji.readings.onyomi),
                if (kanji.readings.kunyomi.isNotEmpty)
                  KanjiReadings(kanji.readings.kunyomi),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
