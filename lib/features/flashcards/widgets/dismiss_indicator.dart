import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class FlashcardDismissIndicator extends HookWidget {
  const FlashcardDismissIndicator({super.key, required this.dismissProgress});

  final double dismissProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = dismissProgress == 1
        ? Colors.lightGreen
        : colorScheme.primary;
    final indicatorColor = useColorSpring(color);

    final armedScale = useValueSpring(
      dismissProgress >= 1 ? 1.25 : 1,
      ratio: 0.5,
      stiffness: 1000,
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
            dismissProgress == 1 ? .check : .arrowOutward,
            size: AppUnit.xlarge * 2,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
