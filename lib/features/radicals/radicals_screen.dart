import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class RadicalsScreen extends HookWidget {
  const RadicalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final radicalsData = context.read<RadicalsData>();
    final groups = radicalsData.entries
        .groupListsBy((e) => e.strokeCount)
        .entries
        .sortedBy((e) => e.key);

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
              onPressed: () => scrollController.animateTo(
                0,
                duration: Durations.long1,
                curve: Curves.easeInOutCubicEmphasized,
              ),
              mini: true,
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              tooltip: s.common_scrollToTop,
              child: const AppIcon(.arrowUpward, size: .large),
            )
          : null,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: viewPadding.add(const AppEdgeInsets.all(.medium)),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: AppPadding(
                    padding: const .symmetric(horizontal: .medium),
                    child: Text(
                      s.radicals_title,
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                AppUnit.medium.sliverGap,
                for (final (index, group) in groups.indexed) ...[
                  if (index > 0) AppUnit.large.sliverGap,
                  SliverToBoxAdapter(
                    child: Container(
                      color: theme.colorScheme.surface,
                      padding: const AppEdgeInsets.symmetric(
                        horizontal: .medium,
                      ),
                      child: Text(
                        s.radicals_strokeCount(group.key),
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  SliverList.separated(
                    itemCount: group.value.length,
                    itemBuilder: (context, index) => _Entry(group.value[index]),
                    separatorBuilder: (context, _) => AppUnit.medium.gap,
                  ),
                ],
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

  final RadicalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: AppPadding(
        padding: const .all(.medium),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              key: ValueKey(entry.id),
              crossAxisAlignment: .start,
              spacing: AppUnit.small,
              children: [
                for (final radical in entry.radicals)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.circular(.small),
                      color: theme.colorScheme.surface,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      radical,
                      style: theme.textTheme.displayMedium
                          ?.apply(color: theme.colorScheme.onSurfaceVariant)
                          .copyWith(height: 1),
                    ),
                  ),
              ],
            ),
            AppUnit.medium.gap,
            Text(entry.names, style: theme.textTheme.titleLarge),
            Text(entry.meaning, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
