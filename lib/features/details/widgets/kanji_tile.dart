import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_animation_dialog.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';

class KanjiTile extends StatelessWidget {
  const KanjiTile(this.kanji, {super.key});

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final contentColor = theme.colorScheme.onSurfaceVariant;

    return Hero(
      tag: KanjiAnimationDialog.heroTag(kanji.kanji),
      createRectTween: KanjiAnimationDialog.createRectTween,
      child: AppCard(
        onTap: () => KanjiAnimationRoute(kanji.id).push<void>(context),
        child: Stack(
          children: [
            AppPadding(
              padding: const .only(
                top: .medium,
                start: .xsmall,
                end: .xsmall,
                bottom: .xsmall,
              ),
              child: Column(
                mainAxisSize: .min,
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
                    mainAxisSize: .min,
                    children: [
                      AppUnit.small.gap,
                      Text(
                        s.kanji_strokeOrder,
                        style: theme.textTheme.bodyLarge?.apply(
                          color: contentColor,
                        ),
                      ),
                      AppIcon(
                        .chevronForward,
                        size: .large,
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppBorderRadius.circular(.small),
                ),
                child: AppPadding(
                  padding: const .symmetric(horizontal: .xsmall),
                  child: Text(
                    kanji.id.toString(),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
