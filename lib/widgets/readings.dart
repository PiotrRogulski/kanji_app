import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class KanjiReadings extends StatelessWidget {
  KanjiReadings(Iterable<String> readings, {super.key})
    : kunyomi = readings.where(_hiraganaRegex.hasMatch).toList(),
      onyomi = readings.whereNot(_hiraganaRegex.hasMatch).toList();

  final List<String> onyomi;
  final List<String> kunyomi;

  static final _hiraganaRegex = RegExp(r'^\p{Script=Hiragana}', unicode: true);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: AppUnit.small,
      crossAxisAlignment: .start,
      children: [
        if (onyomi.isNotEmpty) _ReadingsColumn(onyomi),
        if (kunyomi.isNotEmpty) _ReadingsColumn(kunyomi),
      ],
    );
  }
}

class _ReadingsColumn extends StatelessWidget {
  const _ReadingsColumn(this.readings);

  final List<String> readings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicWidth(
      child: Column(
        spacing: AppUnit.tiny,
        crossAxisAlignment: .stretch,
        children: [
          for (final (index, reading) in readings.indexed)
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorderRadius.vertical(
                  top: index == 0 ? .small : .xsmall,
                  bottom: index == readings.length - 1 ? .small : .xsmall,
                ),
              ),
              child: AppPadding(
                padding: const .symmetric(vertical: .tiny, horizontal: .xsmall),
                child: Text(
                  reading,
                  style: theme.textTheme.bodyLarge?.apply(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
