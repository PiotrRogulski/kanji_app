import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/features/list/kanji_search.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:kanji_app/widgets/readings.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class KanjiListScreen extends HookWidget {
  const KanjiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final kanjiData = context.read<KanjiData>();

    final filteredKanji = useState(kanjiData.entries);

    final searchController = useSyncedTextEditingController((value) {
      final query = value.text.trim();
      if (query.isEmpty) {
        filteredKanji.value = kanjiData.entries;
      } else {
        final matches = {
          for (final e in kanjiData.entries) e: matchEntry(e, query),
        };
        filteredKanji.value = kanjiData.entries
            .where((e) => matches[e] != .none)
            .sortedBy((e) => matches[e]!);
      }
    });

    final scrollController = useScrollController();

    return AppBigTitleScaffold(
      title: s.kanjiList_title,
      scrollController: scrollController,
      cacheExtent: 10_000,
      slivers: [
        AppUnit.xsmall.sliverGap,
        SliverToBoxAdapter(
          child: JDSearchBar(
            controller: searchController,
            hintText: s.kanjiList_search,
          ),
        ),
        AppUnit.medium.sliverGap,
        SliverLayoutBuilder(
          builder: (context, constraints) {
            return SliverMasonryGrid.count(
              crossAxisCount: max(constraints.crossAxisExtent ~/ 320, 1),
              childCount: filteredKanji.value.length,
              itemBuilder: (context, index) =>
                  _Entry(filteredKanji.value[index]),
              crossAxisSpacing: AppUnit.medium,
              mainAxisSpacing: AppUnit.medium,
            );
          },
        ),
      ],
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
          AppPadding(
            padding: const .all(.medium),
            child: Row(
              key: ValueKey(entry.id),
              crossAxisAlignment: .start,
              spacing: AppUnit.large,
              children: [
                Text(
                  entry.kanji,
                  style: theme.textTheme.displayMedium
                      ?.apply(color: theme.colorScheme.onSurfaceVariant)
                      .copyWith(height: 1),
                ),
                if (entry.readings.isNotEmpty) KanjiReadings(entry.readings),
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
