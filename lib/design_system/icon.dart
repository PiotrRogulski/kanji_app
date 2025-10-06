import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system/dynamic_weight.dart';
import 'package:kanji_app/design_system/icons.dart';
import 'package:kanji_app/design_system/sizes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AppIcon extends HookWidget {
  const AppIcon(
    this.icon, {
    super.key,
    required this.size,
    this.color,
    this.fill,
    this.weight,
  });

  final AppIconData icon;
  final AppUnit size;
  final Color? color;
  final double? fill;
  final AppDynamicWeight? weight;

  @override
  Widget build(BuildContext context) {
    final size = useValueSpring(this.size);
    final fill = useValueSpring(
      this.fill ?? DynamicWeight.maybeOf(context)?.fill ?? 0,
    );
    final weight = useValueSpring(
      (this.weight ?? DynamicWeight.maybeOf(context)?.weight ?? .regular).value,
    );
    final color = useColorSpring(this.color ?? IconTheme.of(context).color!);

    return Icon(
      icon,
      size: size,
      opticalSize: size,
      color: color,
      fill: fill,
      weight: weight,
    );
  }
}
