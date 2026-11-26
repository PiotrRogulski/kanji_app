import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

enum AppButtonSize({
  required final double height,
  required final AppUnit padding,
  required final AppUnit pressedRadius,
  required final AppUnit iconSize,
}) {
  small(height: 40, padding: .medium, pressedRadius: .small, iconSize: .medium),
  medium(height: 56, padding: .large, pressedRadius: .medium, iconSize: .large),
}

enum AppButtonVariant() {
  filled,
  text,
}

class const AppButton({
  super.key,
  required final String label,
  required final VoidCallback? onPressed,
  final AppIconData? icon,
  final AppButtonSize size = .medium,
  final AppButtonVariant variant = .filled,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: _AppButton(
        label: label,
        onPressed: onPressed,
        icon: icon,
        size: size,
        variant: variant,
      ),
    );
  }
}

class const _AppButton({
  required final String label,
  required final VoidCallback? onPressed,
  required final AppIconData? icon,
  required final AppButtonSize size,
  required final AppButtonVariant variant,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final enabled = onPressed != null;
    final pressed = DynamicWeight.of(context).pressed;

    final (background, foreground) = switch (variant) {
      _ when !enabled => (
        colorScheme.onSurface.withValues(alpha: variant == .text ? 0 : 0.1),
        colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      .filled => (colorScheme.primary, colorScheme.onPrimary),
      .text => (colorScheme.primary.withValues(alpha: 0), colorScheme.primary),
    };
    final backgroundColor = useColorSpring(background);
    final foregroundColor = useColorSpring(foreground);

    final stadiumProgress = useValueSpring(
      pressed ? 0 : 1,
      spring: Springs.expressiveFastSpatial,
    );

    final textStyle = switch (size) {
      .small => theme.textTheme.labelLarge,
      .medium => theme.textTheme.titleMedium,
    };

    return Material(
      color: backgroundColor,
      shape: StadiumMorphBorder(
        fixedCornerRadius: size.pressedRadius,
        stadiumProgress: stadiumProgress,
      ),
      animationDuration: .zero,
      clipBehavior: .antiAlias,
      child: AppInkWell(
        onTap: switch (onPressed) {
          final onPressed? => () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          null => null,
        },
        child: ConstrainedBox(
          constraints: .new(minHeight: size.height),
          child: AppPadding(
            padding: .symmetric(horizontal: size.padding),
            child: Row(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              spacing: AppUnit.small,
              children: [
                if (icon case final icon?)
                  AppIcon(icon, size: size.iconSize, color: foregroundColor),
                Flexible(
                  child: DynamicWeightText(
                    label,
                    textAlign: icon == null ? .center : .start,
                    maxLines: 1,
                    overflow: .fade,
                    softWrap: false,
                    style: textStyle?.copyWith(color: foregroundColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
