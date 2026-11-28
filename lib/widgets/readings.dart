import 'dart:math';

import 'package:collection/collection.dart';
import 'package:kanji_app/common/text_line_height.dart';
import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

const _readingSpacing = AppUnit.tiny;
const _readingPadding = AppUnit.tiny;

TextStyle? _readingStyle(ThemeData theme) =>
    theme.textTheme.bodyLarge?.apply(color: theme.colorScheme.onSurface);

// https://github.com/dart-lang/sdk/issues/64037
// ignore: prefer_const_constructors_in_immutables
class KanjiReadings(Iterable<String> readings, {super.key})
    extends StatelessWidget {
  final onyomi = readings.whereNot(_hiraganaRegex.hasMatch).toList();
  final kunyomi = readings.where(_hiraganaRegex.hasMatch).toList();

  static final _hiraganaRegex = RegExp(r'^\p{Script=Hiragana}', unicode: true);

  static double Function(Iterable<String> readings) heightIn(
    BuildContext context,
  ) {
    final rowHeight =
        textLineHeight(context, 'あ', _readingStyle(Theme.of(context))) +
        _readingPadding * 2;

    return (readings) {
      final kunyomi = readings.where(_hiraganaRegex.hasMatch).length;
      final rows = max(kunyomi, readings.length - kunyomi);
      return rows * rowHeight + max(rows - 1, 0) * _readingSpacing;
    };
  }

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

class const _ReadingsColumn(final List<String> readings)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            spacing: _readingSpacing,
            crossAxisAlignment: .stretch,
            children: [
              for (var index = 0; index < readings.length; index++)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceBright,
                      borderRadius: AppBorderRadius.vertical(
                        top: index == 0 ? .medium : .xsmall,
                        bottom: index == readings.length - 1
                            ? .medium
                            : .xsmall,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Column(
          mainAxisSize: .min,
          spacing: _readingSpacing,
          crossAxisAlignment: .start,
          children: [
            for (final reading in readings)
              AppPadding(
                padding: const .symmetric(
                  vertical: _readingPadding,
                  horizontal: .xsmall,
                ),
                child: DynamicWeightText(
                  reading,
                  maxLines: 1,
                  softWrap: false,
                  overflow: .fade,
                  reserveBoldWidth: false,
                  style: _readingStyle(theme),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
