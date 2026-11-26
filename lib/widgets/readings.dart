import 'package:collection/collection.dart';
import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

// https://github.com/dart-lang/sdk/issues/64037
// ignore: prefer_const_constructors_in_immutables
class KanjiReadings(Iterable<String> readings, {super.key})
    extends StatelessWidget {
  final onyomi = readings.whereNot(_hiraganaRegex.hasMatch).toList();
  final kunyomi = readings.where(_hiraganaRegex.hasMatch).toList();

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

class const _ReadingsColumn(final List<String> readings)
    extends StatelessWidget {
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
                  top: index == 0 ? .medium : .xsmall,
                  bottom: index == readings.length - 1 ? .medium : .xsmall,
                ),
              ),
              child: AppPadding(
                padding: const .symmetric(vertical: .tiny, horizontal: .xsmall),
                child: DynamicWeightText(
                  reading,
                  maxLines: 1,
                  softWrap: false,
                  overflow: .fade,
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
