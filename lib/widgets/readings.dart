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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, reading) in readings.indexed)
            Container(
              padding: const AppPadding.symmetric(
                vertical: AppUnit.tiny,
                horizontal: AppUnit.xsmall,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorderRadius.vertical(
                  top: index == 0 ? AppUnit.small : AppUnit.xsmall,
                  bottom: index == readings.length - 1
                      ? AppUnit.small
                      : AppUnit.xsmall,
                ),
              ),
              child: Text(
                reading,
                style: theme.textTheme.bodyLarge?.apply(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
