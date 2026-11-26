import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_animation_dialog.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:material_ui/material_ui.dart';

class const KanjiTile(
  final KanjiEntry kanji, {
  final bool connectedBelow = false,
  super.key,
}) extends StatelessWidget {
  static const _glyphSize = 160.0;
  static const _footerHeight = 40.0;

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
        borderRadius: .vertical(
          top: AppCard.defaultRadius,
          bottom: connectedBelow ? .xsmall : AppCard.defaultRadius,
        ),
        child: Stack(
          children: [
            AppPadding(
              padding: const .only(
                top: .medium,
                start: .small,
                end: .small,
                bottom: .xsmall,
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    kanji.kanji,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: _glyphSize,
                      color: contentColor,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    height: _footerHeight,
                    child: Row(
                      children: [
                        AppUnit.small.gap,
                        Expanded(
                          child: DynamicWeightText(
                            s.kanji_strokeOrder,
                            maxLines: 1,
                            overflow: .fade,
                            softWrap: false,
                            style: theme.textTheme.bodyMedium?.apply(
                              color: contentColor,
                            ),
                          ),
                        ),
                        AppIcon(
                          .chevronForward,
                          size: .large,
                          color: contentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: AppUnit.small + AppUnit.xsmall,
              start: AppUnit.medium,
              child: DynamicWeightText(
                kanji.id.toString(),
                style: theme.textTheme.labelLarge?.apply(color: contentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
