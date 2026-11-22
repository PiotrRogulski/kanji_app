import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:material_ui/material_ui.dart';

class const RadicalEntryView(final RadicalEntry entry, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              RadicalRelatedForms(entry),
              AppUnit.small.gap,
            ],
            RadicalExamples(entry),
          ],
        ),
      ),
    );
  }
}

class const RadicalRelatedForms(
  final RadicalEntry entry, {
  final Iterable<String> otherForms = const [],
  final WrapAlignment alignment = .start,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return Wrap(
      spacing: AppUnit.xsmall,
      runSpacing: AppUnit.xsmall,
      alignment: alignment,
      crossAxisAlignment: .center,
      children: [
        Text(
          s.radicals_relatedRadicals,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        for (final form in otherForms) _RelatedRadicalChip(radical: form),
        for (final related in entry.relatedRadicals)
          _RelatedRadicalChip(
            radical: related.radical,
            strokeCount: related.strokeCount,
          ),
      ],
    );
  }
}

class const RadicalExamples(final RadicalEntry entry, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppBorderRadius.circular(AppUnit.small + AppUnit.xsmall),
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
          Text(s.radicals_exampleKanji, style: theme.textTheme.bodyLarge),
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
                  child: Text(kanji, style: theme.textTheme.headlineLarge),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class const _RelatedRadicalChip({
  required final String radical,
  final int? strokeCount,
}) extends StatelessWidget {
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
              radical,
              style: theme.textTheme.titleLarge?.apply(color: foregroundColor),
            ),
            if (strokeCount case final strokeCount?)
              Text(
                s.radicals_strokeCount(strokeCount),
                style: theme.textTheme.bodyLarge?.apply(color: foregroundColor),
              ),
          ],
        ),
      ),
    );
  }
}
