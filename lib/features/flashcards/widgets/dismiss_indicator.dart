import 'dart:ui';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

class const FlashcardDismissIndicator({
  super.key,
  required final Offset dragOffset,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final dismissProgress = dragOffset.dismissProgress;
    final isArmed = dismissProgress >= 1;
    final isSkip = dragOffset.dx < 0;

    final armedColor = isSkip ? Colors.orange : Colors.lightGreen;
    final indicatorColor = useColorSpring(
      isArmed ? armedColor : colorScheme.primary,
    );

    final armedScale = useValueSpring(
      isArmed ? 1.5 : 1,
      spring: Springs.expressiveFastSpatial,
    );

    return Transform.scale(
      scale: lerpDouble(0.5, 1, dismissProgress)! * armedScale,
      child: LiquidGlass.auto(
        shape: const LiquidOval(),
        settings: appLiquidGlassSettings,
        appearance: appLiquidGlassAppearance.copyWith(
          visibility: dismissProgress,
          tint: indicatorColor.withValues(alpha: 0.25),
          colorModel: const .direct(saturation: 2),
        ),
        child: AppPadding(
          padding: const .all(.small),
          child: AppIcon(
            isSkip ? .undo : .check,
            size: AppUnit.xlarge * 2,
            color: colorScheme.onPrimary,
            weight: isArmed ? .bold : .light,
          ),
        ),
      ),
    );
  }
}
