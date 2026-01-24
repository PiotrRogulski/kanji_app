import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/app_coordinator.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

typedef _SliverWordsSectionData = ({
  String title,
  List<KanjiWord> words,
  bool showRef,
});

class SliverKanjiWords extends StatelessWidget {
  const SliverKanjiWords({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final entry = context.watch<KanjiEntry>();

    final sections = [
      if (entry.wordsRequiredNow.isNotEmpty)
        (
          title: s.kanji_wordsRequiredNow,
          words: entry.wordsRequiredNow,
          showRef: false,
        ),
      if (entry.wordsRequiredLater.isNotEmpty)
        (
          title: s.kanji_wordsRequiredLater,
          words: entry.wordsRequiredLater,
          showRef: true,
        ),
      if (entry.additionalWords.isNotEmpty)
        (
          title: s.kanji_additionalWords,
          words: entry.additionalWords,
          showRef: false,
        ),
    ];

    return SliverMainAxisGroup(
      slivers: [
        for (final (i, section) in sections.indexed) ...[
          if (i > 0) AppUnit.large.sliverGap,
          _SliverWordsSection(section),
        ],
      ],
    );
  }
}

class _SliverWordsSection extends StatelessWidget {
  const _SliverWordsSection(this.section);

  final _SliverWordsSectionData section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: AppPadding(
            padding: const .symmetric(horizontal: .small),
            child: Text(section.title, style: theme.textTheme.headlineSmall),
          ),
        ),
        AppUnit.tiny.sliverGap,
        SliverList.separated(
          itemCount: section.words.length,
          itemBuilder: (context, i) => _WordTile(
            section.words[i],
            section.words,
            showReference: section.showRef,
          ),
          separatorBuilder: (context, _) => AppUnit.small.gap,
        ),
      ],
    );
  }
}

class _WordTile extends StatelessWidget {
  const _WordTile(this.word, this.allWords, {this.showReference = false});

  final KanjiWord word;
  final List<KanjiWord> allWords;
  final bool showReference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final maxWordLength = allWords.map((w) => w.kanji.length).max;

    return AppCard(
      child: AppPadding(
        padding: .only(
          start: .small,
          end: .small,
          top: .small,
          bottom: word.reference == null ? .xsmall : .small,
        ),
        child: Column(
          spacing: AppUnit.xsmall,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                for (final c
                    in word.kanji.padRight(maxWordLength, '　').characters)
                  DynamicWeight(child: _SearchableKanji(kanji: c)),
                AppUnit.xlarge.gap,
                Text(word.reading, style: theme.textTheme.bodyLarge),
              ],
            ),
            if (word.meaning.isNotEmpty)
              Text(word.meaning, style: theme.textTheme.bodyLarge),
            if (word.reference case final reference?) ...[
              FilledButton(
                onPressed: () => AppCoordinator.instance.toDetails(reference),
                style: FilledButton.styleFrom(
                  padding: const AppEdgeInsets.symmetric(horizontal: .medium),
                ),
                child: Text('#$reference'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchableKanji extends HookWidget {
  const _SearchableKanji({required this.kanji});

  final String kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final kanjiData = context.watch<KanjiData>();
    final currentEntry = context.watch<KanjiEntry>();
    final targetEntry = kanjiData.entries.firstWhereOrNull(
      (e) => e.kanji == kanji,
    );

    final controller = DynamicWeight.of(context).controller;
    final active = useListenableSelector(
      controller,
      () => (WidgetState.hovered | WidgetState.pressed).isSatisfiedBy(
        controller.value,
      ),
    );

    final searchable =
        kanji != '　' && kanji != currentEntry.kanji && targetEntry != null;

    final opacity = useValueSpring(active ? 1 : 0);
    final scale = useValueSpring(active ? 1 : 0, ratio: active ? 0.5 : null);
    final textColor = useColorSpring(
      active ? colorScheme.onPrimary : colorScheme.onSurface,
    );

    return Stack(
      clipBehavior: .none,
      children: [
        if (searchable)
          Positioned.fill(
            left: -AppUnit.tiny,
            right: -AppUnit.tiny,
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: AppBorderRadius.circular(.small),
                  ),
                ),
              ),
            ),
          ),

        Text(
          kanji,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: textColor,
            decoration: searchable ? .underline : null,
            decorationColor: colorScheme.primary,
            decorationStyle: .dotted,
          ),
        ),

        if (searchable)
          Positioned.fill(
            left: -AppUnit.tiny,
            right: -AppUnit.tiny,
            child: Theme(
              data: Theme.of(context).copyWith(hoverColor: Colors.transparent),
              child: Material(
                type: .transparency,
                child: AppInkWell(
                  borderRadius: .circular(.small),
                  onTap: () =>
                      AppCoordinator.instance.toDetails(targetEntry.id),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
