import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:kanji_app/features/radicals/radical_entry_view.dart';
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

    return AppBigTitleScaffold(
      title: s.radicals_title,
      scrollController: scrollController,
      slivers: [
        AppUnit.medium.sliverGap,
        for (final (index, group) in groups.indexed) ...[
          if (index > 0) AppUnit.large.sliverGap,
          SliverToBoxAdapter(
            child: Container(
              color: theme.colorScheme.surface,
              padding: const AppEdgeInsets.symmetric(horizontal: .medium),
              child: Text(
                s.radicals_strokeCount(group.key),
                style: theme.textTheme.headlineLarge,
              ),
            ),
          ),
          SliverList.separated(
            itemCount: group.value.length,
            itemBuilder: (context, index) =>
                RadicalEntryView(group.value[index]),
            separatorBuilder: (context, _) => AppUnit.medium.gap,
          ),
        ],
      ],
    );
  }
}
