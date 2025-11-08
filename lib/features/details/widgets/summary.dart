import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/widgets/readings.dart';

class KanjiSummary extends StatelessWidget {
  const KanjiSummary({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Wrap(
        spacing: AppUnit.small,
        runSpacing: AppUnit.small,
        children: [KanjiTile(entry), _Readings(entry)],
      ),
    );
  }
}

class _Readings extends StatelessWidget {
  const _Readings(this.kanji);

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return AppCard(
      child: AppPadding(
        padding: const .all(.xsmall),
        child: Column(
          spacing: AppUnit.tiny,
          crossAxisAlignment: .start,
          children: [
            AppPadding(
              padding: const .symmetric(horizontal: .xsmall),
              child: Text(s.kanji_readings, style: theme.textTheme.bodyLarge),
            ),
            KanjiReadings(kanji.readings),
          ],
        ),
      ),
    );
  }
}
