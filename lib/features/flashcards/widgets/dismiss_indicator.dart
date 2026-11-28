import 'dart:ui';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/theme.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

class const FlashcardDismissIndicator({
  super.key,
  required final Offset dragOffset,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final answerColors = theme.extension<FlashcardColors>()!;

    final dismissProgress = dragOffset.dismissProgress;
    final isArmed = dismissProgress >= 1;
    final isSkip = dragOffset.dx < 0;

    final colorScheme = isArmed
        ? isSkip
              ? answerColors.skipped
              : answerColors.learned
        : theme.colorScheme;

    final indicatorColor = useColorSpring(colorScheme.primaryContainer);

    final armedScale = useValueSpring(
      isArmed ? 1.5 : 1,
      spring: Springs.expressiveFastSpatial,
    );

    return Transform.scale(
      scale: lerpDouble(0.5, 1, dismissProgress)! * armedScale,
      child: LiquidGlass.auto(
        shape: const LiquidOval(),
        settings: appLiquidGlassSettings,
        appearance: appGlassAppearanceOf(context).copyWith(
          visibility: dismissProgress,
          tint: indicatorColor.withValues(alpha: 0.5),
          colorModel: const .direct(saturation: 1.5, transmissionGamma: 0.5),
        ),
        child: AppPadding(
          padding: const .all(.small),
          child: AppIcon(
            isSkip ? .undo : .check,
            size: AppUnit.xlarge * 2,
            color: colorScheme.onPrimaryContainer,
            weight: isArmed ? .bold : .light,
          ),
        ),
      ),
    );
  }
}
