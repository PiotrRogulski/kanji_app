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
      child: AppPadding(
        padding: const .all(.xsmall),
        child: IntrinsicWidth(
          child: Column(
            spacing: AppUnit.tiny,
            crossAxisAlignment: .stretch,
            children: [
              AppPadding(
                padding: const .symmetric(horizontal: .xsmall),
                child: Text(s.kanji_readings, style: theme.textTheme.bodyLarge),
              ),
              KanjiReadings(kanji.readings),
            ],
          ),
        ),
      ),
    );
  }
}
