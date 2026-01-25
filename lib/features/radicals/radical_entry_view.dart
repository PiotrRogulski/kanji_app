import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';

class RadicalEntryView extends StatelessWidget {
  const RadicalEntryView(this.entry, {super.key});

  final RadicalEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return AppCard(
      child: AppPadding(
        padding: const .all(.medium),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Wrap(
              spacing: AppUnit.medium,
              runSpacing: AppUnit.small,
              crossAxisAlignment: .center,
              children: [
                Row(
                  crossAxisAlignment: .start,
                  spacing: AppUnit.small,
                  mainAxisSize: .min,
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
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(entry.names, style: theme.textTheme.titleLarge),
                    Text(entry.meaning, style: theme.textTheme.titleMedium),
                  ],
                ),
              ],
            ),
            AppUnit.small.gap,
            if (entry.relatedRadicals.isNotEmpty) ...[
              Wrap(
                spacing: AppUnit.xsmall,
                runSpacing: AppUnit.xsmall,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    s.radicals_relatedRadicals,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  for (final related in entry.relatedRadicals)
                    _RelatedRadicalChip(related),
                ],
              ),
              AppUnit.small.gap,
            ],
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorderRadius.circular(
                  AppUnit.small + AppUnit.xsmall,
                ),
              ),
              padding: const AppEdgeInsets.only(
                start: .small,
                end: .xsmall,
                top: .xsmall,
                bottom: .xsmall,
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Text(
                    s.radicals_exampleKanji,
                    style: theme.textTheme.bodyLarge,
                  ),
                  AppUnit.small.gap,
                  Row(
                    spacing: AppUnit.tiny,
                    mainAxisSize: .min,
                    children: [
                      for (final (index, kanji) in entry.examples.indexed)
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppBorderRadius.horizontal(
                              start: index == 0 ? .small : .xsmall,
                              end: index == entry.examples.length - 1
                                  ? .small
                                  : .xsmall,
                            ),
                          ),
                          alignment: .center,
                          child: Text(
                            kanji,
                            style: theme.textTheme.headlineLarge,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedRadicalChip extends StatelessWidget {
  const _RelatedRadicalChip(this.related);

  final RelatedRadical related;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.surfaceContainer;
    final foregroundColor = theme.colorScheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppBorderRadius.circular(.small),
        border: .all(color: foregroundColor.withValues(alpha: 0.25)),
      ),
      child: AppPadding(
        padding: const .symmetric(horizontal: .small, vertical: .xsmall),
        child: Row(
          mainAxisSize: .min,
          spacing: AppUnit.small,
          children: [
            Text(
              related.radical,
              style: theme.textTheme.titleLarge?.apply(color: foregroundColor),
            ),
            Text(
              s.radicals_strokeCount(related.strokeCount),
              style: theme.textTheme.bodyLarge?.apply(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
