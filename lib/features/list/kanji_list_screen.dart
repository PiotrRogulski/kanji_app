import 'dart:math';

import 'package:collection/collection.dart';
import 'package:kanji_app/common/text_line_height.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/features/list/kanji_search.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:kanji_app/widgets/readings.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const KanjiListScreen({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final kanjiData = context.watch<KanjiData>();

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

    final entryHeight = _Entry.heightIn(context);

    return AppBigTitleScaffold(
      title: s.kanjiList_title,
      scrollController: scrollController,
      pinnedHeader: JDSearchBar(
        controller: searchController,
        hintText: s.kanjiList_search,
      ),
      slivers: [
        AppUnit.medium.sliverGap,
        SliverMasonryGrid(
          itemExtents: filteredKanji.value.map(entryHeight).toList(),
          minCrossAxisExtent: 320,
          spacing: AppUnit.medium,
          delegate: SliverChildBuilderDelegate(
            (context, index) => _Entry(filteredKanji.value[index]),
            childCount: filteredKanji.value.length,
          ),
        ),
      ],
    );
  }
}

class const _Entry(final KanjiEntry entry) extends StatelessWidget {
  static const _padding = AppUnit.medium;

  static TextStyle? _kanjiStyle(ThemeData theme) => theme
      .textTheme
      .displayMedium
      ?.apply(color: theme.colorScheme.onSurfaceVariant)
      .copyWith(height: 1);

  static double Function(KanjiEntry entry) heightIn(BuildContext context) {
    final kanjiHeight = textLineHeight(
      context,
      '字',
      _kanjiStyle(Theme.of(context)),
    );
    final readingsHeight = KanjiReadings.heightIn(context);

    return (entry) =>
        max(kanjiHeight, readingsHeight(entry.readings)) + _padding * 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => KanjiDetailsRoute(entry.id).go(context),
      child: Stack(
        children: [
          AppPadding(
            padding: const .all(_padding),
            child: Row(
              key: ValueKey(entry.id),
              crossAxisAlignment: .start,
              spacing: AppUnit.large,
              children: [
                Text(entry.kanji, style: _kanjiStyle(theme)),
                if (entry.readings.isNotEmpty) KanjiReadings(entry.readings),
              ],
            ),
          ),
          PositionedDirectional(
            start: AppUnit.medium,
            top: AppUnit.xsmall,
            child: DynamicWeightText(
              entry.id.toString(),
              reserveBoldWidth: false,
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
