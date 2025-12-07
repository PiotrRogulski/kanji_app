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
                              left: index == 0 ? .small : .xsmall,
                              right: index == entry.examples.length - 1
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
