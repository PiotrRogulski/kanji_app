import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/widgets/readings.dart';

class KanjiReadingsGroup extends StatelessWidget {
  const KanjiReadingsGroup(this.kanji, {super.key});

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const AppPadding.all(AppUnit.xsmall),
        child: Column(
          spacing: AppUnit.tiny,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const AppPadding.symmetric(horizontal: AppUnit.xsmall),
              child: Text(s.kanji_readings, style: theme.textTheme.bodyLarge),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppUnit.small,
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
