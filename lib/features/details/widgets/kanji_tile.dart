import 'package:flutter/material.dart';
import 'package:kanji_app/design_system/card.dart';
import 'package:kanji_app/design_system/icon.dart';
import 'package:kanji_app/design_system/icons.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class KanjiTile extends StatelessWidget {
  const KanjiTile(this.kanji, {super.key});

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final contentColor = theme.colorScheme.onSurfaceVariant;

    return AppCard(
      onTap: () {
        // TODO: Open kanji stroke animation
        debugPrint('Tapped on kanji tile: ${kanji.kanji}');
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Text(
                  kanji.kanji,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 160,
                    color: contentColor,
                    height: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'Kolejność pisania',
                      style: theme.textTheme.bodyLarge?.apply(
                        color: contentColor,
                      ),
                    ),
                    AppIcon(
                      AppIconData.chevronForward,
                      size: 24,
                      color: contentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 4,
            start: 4,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                kanji.id.toString(),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
