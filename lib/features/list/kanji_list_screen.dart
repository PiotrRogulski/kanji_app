import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system/card.dart';
import 'package:kanji_app/design_system/icon.dart';
import 'package:kanji_app/design_system/icons.dart';
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
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Znaki',
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                PinnedHeaderSliver(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SearchBar(
                      controller: searchController,
                      elevation: const WidgetStatePropertyAll(0),
                      hintText: 'Szukaj znaków',
                      leading: Padding(
                        padding: const EdgeInsets.all(12),
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
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
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
            start: 8,
            top: 4,
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
