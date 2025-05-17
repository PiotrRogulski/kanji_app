import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
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
            padding: const AppPadding.all(AppUnit.xsmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppUnit.medium,
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
                    AppUnit.small.gap,
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
            top: AppUnit.xsmall,
            start: AppUnit.xsmall,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorderRadius.circular(AppUnit.small),
              ),
              padding: const AppPadding.symmetric(horizontal: AppUnit.xsmall),
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
