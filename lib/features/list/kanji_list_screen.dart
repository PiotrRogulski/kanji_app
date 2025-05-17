import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/list_branch.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:kanji_app/widgets/readings.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class KanjiListScreen extends HookWidget {
  const KanjiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final kanjiData = context.read<KanjiData>();

    final filteredKanji = useState(kanjiData.entries);

    final searchController = useSyncedTextEditingController((value) {
      if (value.text.isEmpty) {
        filteredKanji.value = kanjiData.entries;
      } else {
        final scores = {
          for (final e in kanjiData.entries) e.id: ?_entryMatch(e, value.text),
        };
        filteredKanji.value = kanjiData.entries
            .where((e) => scores.containsKey(e.id))
            .sortedBy((e) => scores[e.id]!);
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const AppPadding.all(AppUnit.large),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const AppPadding.symmetric(
                      horizontal: AppUnit.large,
                    ),
                    child: Text(
                      s.kanjiList_title,
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                PinnedHeaderSliver(
                  child: Padding(
                    padding: const AppPadding.symmetric(
                      vertical: AppUnit.large,
                    ),
                    child: SearchBar(
                      controller: searchController,
                      elevation: const WidgetStatePropertyAll(0),
                      hintText: s.kanjiList_search,
                      leading: Padding(
                        padding: const AppPadding.all(AppUnit.medium),
                        child: AppIcon(
                          AppIconData.search,
                          size: 24,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: filteredKanji.value.length,
                  separatorBuilder: (_, _) => AppUnit.large.gap,
                  itemBuilder: (context, index) =>
                      _Entry(filteredKanji.value[index]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry(this.entry);

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => KanjiDetailsRoute(entry.id).go(context),
      child: Stack(
        children: [
          Padding(
            padding: const AppPadding.all(AppUnit.large),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUnit.large,
              children: [
                Text(
                  entry.kanji,
                  style: theme.textTheme.displayMedium
                      ?.apply(color: theme.colorScheme.onSurfaceVariant)
                      .copyWith(height: 1),
                ),
                if (entry.readings.onyomi.isNotEmpty)
                  KanjiReadings(entry.readings.onyomi),
                if (entry.readings.kunyomi.isNotEmpty)
                  KanjiReadings(entry.readings.kunyomi),
              ],
            ),
          ),
          PositionedDirectional(
            start: AppUnit.small,
            top: AppUnit.xsmall,
            child: Text(
              entry.id.toString(),
              style: theme.textTheme.labelSmall?.apply(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int? _entryMatch(KanjiEntry entry, String query) {
  // TODO: search more fuzzily
  if (entry.kanji == query) {
    return 1;
  }

  if (entry.readings.onyomi.contains(query) ||
      entry.readings.kunyomi.contains(query)) {
    return 2;
  }

  if (entry.readings.onyomi.any((r) => r.contains(query)) ||
      entry.readings.kunyomi.any((r) => r.contains(query))) {
    return 3;
  }

  return null;
}
