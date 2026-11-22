import 'dart:ui';

import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
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

    final icon = isSkip ? AppIconData.undo : AppIconData.check;
    final armedColor = isSkip ? Colors.orange : Colors.lightGreen;
    final color = isArmed ? armedColor : colorScheme.primary;
    final indicatorColor = useColorSpring(color);

    final armedScale = useValueSpring(
      isArmed ? 1.5 : 1,
      spring: Springs.expressiveFastSpatial,
    );

    return Opacity(
      opacity: dismissProgress,
      child: Transform.scale(
        scale: lerpDouble(0.5, 1, dismissProgress)! * armedScale,
        child: Container(
          padding: const AppEdgeInsets.all(.small),
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: .circle,
            border: Border.all(color: indicatorColor, width: 2),
          ),
          child: AppIcon(
            icon,
            size: AppUnit.xlarge * 2,
            color: colorScheme.onPrimary,
            weight: isArmed ? .bold : .light,
          ),
        ),
      ),
    );
  }
}
