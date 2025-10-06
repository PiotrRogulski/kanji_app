import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class SliverKanjiWords extends StatelessWidget {
  const SliverKanjiWords({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: AppPadding(
            padding: const .symmetric(horizontal: .small),
            child: Text('Słowa', style: theme.textTheme.headlineSmall),
          ),
        ),
        AppUnit.tiny.sliverGap,
        SliverList.separated(
          itemCount: entry.words.length,
          itemBuilder: (context, index) => _WordTile(entry, index),
          separatorBuilder: (context, _) => AppUnit.small.gap,
        ),
      ],
    );
  }
}

class _WordTile extends StatelessWidget {
  const _WordTile(this.entry, this.index);

  final KanjiEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final word = entry.words[index];

    final maxWordLength = entry.words.map((w) => w.word.length).max;

    return AppCard(
      child: AppPadding(
        padding: .only(
          start: .small,
          end: .small,
          top: .small,
          bottom: word.related.isNotEmpty ? .small : .xsmall,
        ),
        child: Column(
          spacing: AppUnit.xsmall,
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: AppUnit.xlarge,
              children: [
                Text(
                  word.word.padRight(maxWordLength, '　'),
                  style: theme.textTheme.headlineSmall,
                ),
                Text(word.reading, style: theme.textTheme.bodyLarge),
              ],
            ),
            Text(word.meaning, style: theme.textTheme.bodyLarge),
            if (word.related.isNotEmpty) _RelatedWords(word),
          ],
        ),
      ),
    );
  }
}

class _RelatedWords extends StatelessWidget {
  const _RelatedWords(this.baseWord);

  final Word baseWord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      spacing: AppUnit.tiny,
      crossAxisAlignment: .stretch,
      children: [
        for (final (index, word) in baseWord.related.indexed)
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppBorderRadius.vertical(
                top: index == 0 ? .xsmall : null,
                bottom: index == baseWord.related.length - 1 ? .xsmall : null,
              ),
              color: theme.colorScheme.surface,
            ),
            child: AppPadding(
              padding: const .symmetric(horizontal: .small, vertical: .xsmall),
              child: Row(
                crossAxisAlignment: .baseline,
                textBaseline: .alphabetic,
                spacing: AppUnit.medium,
                children: [
                  Text.rich(
                    _buildRelatedWordSpan(baseWord, word, theme),
                    style: theme.textTheme.bodyMedium,
                  ),
                  Expanded(
                    child: Text(
                      word.meaning,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

InlineSpan _buildRelatedWordSpan(
  Word baseWord,
  RelatedWord related,
  ThemeData theme,
) {
  final [_, suffix] = related.word.split('＿');

  final maxSuffixLength = baseWord.related.map((r) => r.word.length).max - 1;

  return TextSpan(
    children: [
      TextSpan(
        text: baseWord.word,
        style: .new(color: theme.colorScheme.outlineVariant),
      ),
      TextSpan(text: suffix.padRight(maxSuffixLength, '　')),
    ],
    style: theme.textTheme.bodyLarge,
  );
}
