import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_animation_dialog.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class KanjiTile extends StatelessWidget {
  const KanjiTile(this.kanji, {super.key});

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final contentColor = theme.colorScheme.onSurfaceVariant;

    return Hero(
      tag: 'kanji-${kanji.kanji}',
      child: AppCard(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            PageRouteBuilder<void>(
              opaque: false,
              barrierDismissible: true,
              // barrierColor: theme.colorScheme.surface,
              transitionsBuilder: (context, animation, _, child) {
                final value = animation.value;

                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8 * value,
                    sigmaY: 8 * value,
                    tileMode: TileMode.clamp,
                  ),
                  child: child,
                );
              },
              pageBuilder: (context, _, _) {
                return Center(
                  child: Hero(
                    tag: 'kanji-${kanji.kanji}',
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final biggest = constraints.biggest;
                        return SizedBox.square(
                          dimension: min(
                            biggest.shortestSide - 2 * AppUnit.xlarge,
                            400,
                          ),
                          child: KanjiAnimationDialog(kanji.kanji),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
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
                        s.kanji_strokeOrder,
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
      ),
    );
  }
}
