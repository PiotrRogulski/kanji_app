import 'package:flutter/material.dart';

class KanjiReadings extends StatelessWidget {
  const KanjiReadings(this.readings, {super.key});

  final List<String> readings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicWidth(
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, reading) in readings.indexed)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(index == 0 ? 8 : 4),
                  bottom: Radius.circular(index == readings.length - 1 ? 8 : 4),
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
