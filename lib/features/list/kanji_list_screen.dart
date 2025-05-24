import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
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
    final theme = Theme.of(context);

    final kanjiData = context.read<KanjiData>();

    final filteredKanji = useState(kanjiData.entries);

    final searchController = useSyncedTextEditingController((value) {
      if (value.text.isEmpty) {
        filteredKanji.value = kanjiData.entries;
      } else {
        final matches = {
          for (final e in kanjiData.entries) e: matchEntry(e, value.text),
        };
        filteredKanji.value = kanjiData.entries
            .where((e) => matches[e] != SearchMatch.none)
            .sortedBy((e) => matches[e]!);
      }
    });

    final scrollController = useScrollController();
    final position = useListenableSelector(
      scrollController,
      () => scrollController.hasClients ? scrollController.offset : 0,
    );

    final viewPadding = MediaQuery.viewPaddingOf(context);

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: position > 0
          ? FloatingActionButton(
              onPressed: () {
                if (position > 500) {
                  scrollController.jumpTo(500);
                }
                scrollController.animateTo(
                  0,
                  duration: Durations.long1,
                  curve: Curves.easeInOutCubicEmphasized,
                );
              },
              mini: true,
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              tooltip: s.kanjiList_scrollToTop,
              child: const AppIcon(AppIconData.arrowUpward, size: 24),
            )
          : null,
      body: CustomScrollView(
        controller: scrollController,
        cacheExtent: 10_000,
        slivers: [
          SliverPadding(
            padding: viewPadding.add(const AppPadding.all(AppUnit.large)),
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
                AppUnit.xsmall.sliverGap,
                SliverToBoxAdapter(
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
                    trailing: [
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: searchController.clear,
                          icon: const AppIcon(AppIconData.close, size: 24),
                        ),
                    ],
                  ),
                ),
                AppUnit.large.sliverGap,
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    return SliverMasonryGrid.count(
                      crossAxisCount: constraints.crossAxisExtent ~/ 290,
                      childCount: filteredKanji.value.length,
                      itemBuilder: (context, index) =>
                          _Entry(filteredKanji.value[index]),
                      crossAxisSpacing: AppUnit.large,
                      mainAxisSpacing: AppUnit.large,
                    );
                  },
                ),
                const SliverGap(48),
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
              key: ValueKey(entry.id),
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
