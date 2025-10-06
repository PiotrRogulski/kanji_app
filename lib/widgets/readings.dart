import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class KanjiReadings extends StatelessWidget {
  const KanjiReadings(this.readings, {super.key});

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
