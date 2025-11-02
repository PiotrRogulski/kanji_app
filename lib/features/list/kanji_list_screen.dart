import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/search_bar.dart';
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
    final position = useListenableSelector(
      scrollController,
      () => scrollController.hasClients ? scrollController.offset : 0,
    );

    final viewPadding = MediaQuery.viewPaddingOf(context);

    return Scaffold(
      floatingActionButtonLocation: .miniCenterFloat,
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
              child: const AppIcon(.arrowUpward, size: .large),
            )
          : null,
      body: CustomScrollView(
        controller: scrollController,
        cacheExtent: 10_000,
        slivers: [
          SliverPadding(
            padding: viewPadding.add(const AppEdgeInsets.all(.medium)),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: AppPadding(
                    padding: const .symmetric(horizontal: .medium),
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
                  child: JDSearchBar(
                    controller: searchController,
                    hintText: s.kanjiList_search,
                  ),
                ),
                AppUnit.medium.sliverGap,
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    return SliverMasonryGrid.count(
                      crossAxisCount: constraints.crossAxisExtent ~/ 320,
                      childCount: filteredKanji.value.length,
                      itemBuilder: (context, index) =>
                          _Entry(filteredKanji.value[index]),
                      crossAxisSpacing: AppUnit.medium,
                      mainAxisSpacing: AppUnit.medium,
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
