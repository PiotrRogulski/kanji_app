import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const AppIcon(
  final AppIconData icon, {
  super.key,
  required final AppUnit size,
  final Color? color,
  final double? fill,
  final AppDynamicWeight? weight,
}) extends HookWidget {
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

    return AnimatedSwitcher(
      duration: Durations.medium1,
      switchInCurve: Curves.easeInOutCubicEmphasized,
      switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: Icon(
        key: ValueKey(icon),
        icon.iconData,
        size: size,
        opticalSize: size,
        color: color,
        fill: fill,
        weight: weight,
      ),
    );
  }
}
