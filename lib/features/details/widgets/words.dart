import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';

typedef _SliverWordsSectionData = ({
  String title,
  List<KanjiWord> words,
  bool showRef,
});

class SliverKanjiWords extends StatelessWidget {
  const SliverKanjiWords({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

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
                Text(
                  word.kanji.padRight(maxWordLength, '　'),
                  style: theme.textTheme.headlineSmall,
                ),
                AppUnit.xlarge.gap,
                Text(word.reading, style: theme.textTheme.bodyLarge),
              ],
            ),
            if (word.meaning.isNotEmpty)
              Text(word.meaning, style: theme.textTheme.bodyLarge),
            if (word.reference case final reference?) ...[
              FilledButton(
                onPressed: () =>
                    KanjiDetailsRoute(reference).push<void>(context),
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
