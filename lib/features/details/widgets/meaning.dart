import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const KanjiMeaning({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = context.watch<KanjiEntry>();

    final [primary, ...others] = entry.meaning.split('; ');

    return AppPadding(
      padding: const .symmetric(horizontal: .small),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            primary,
            style: theme.textTheme.displayMedium?.apply(
              color: theme.colorScheme.secondary,
            ),
          ),
          if (others.isNotEmpty)
            Text(
              others.join(' · '),
              style: theme.textTheme.headlineSmall?.apply(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
