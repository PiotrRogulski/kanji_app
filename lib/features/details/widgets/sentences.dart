import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class SliverKanjiSentences extends StatelessWidget {
  const SliverKanjiSentences({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entry.sentences.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: AppPadding(
            padding: const .symmetric(horizontal: .small),
            child: Text('Zdania', style: theme.textTheme.headlineSmall),
          ),
        ),
        AppUnit.tiny.sliverGap,
        SliverList.separated(
          itemCount: entry.sentences.length,
          itemBuilder: (context, index) =>
              _SentenceTile(entry.sentences[index]),
          separatorBuilder: (context, _) => AppUnit.small.gap,
        ),
      ],
    );
  }
}

class _SentenceTile extends StatelessWidget {
  const _SentenceTile(this.sentence);

  final String sentence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: AppPadding(
        padding: const .all(.small),
        child: Text(sentence, style: theme.textTheme.bodyLarge),
      ),
    );
  }
}
