import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/widgets/readings.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const KanjiSummary({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entry = context.watch<KanjiEntry>();

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

class const _Readings(final KanjiEntry kanji) extends StatelessWidget {
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
