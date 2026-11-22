import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system/motion.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

enum SpringState({required final double value}) {
  first(value: 0),
  second(value: 1),
}

double useValueSpring(
  double value, {
  SpringDescription? spring,
  bool animate = true,
}) {
  final controller = useUnboundedAnimationController(initialValue: value);
  useValueChanged<(double, bool), void>((value, animate), (_, _) {
    if (animate) {
      controller.springTo(value, spring: spring);
    } else {
      controller.value = value;
    }
  });

  return useAnimation(controller);
}

ShapeBorder useShapeSpring({
  required RoundedPolygon first,
  required RoundedPolygon second,
  required SpringState state,
  SpringDescription? spring,
}) {
  final progress = useValueSpring(
    state.value,
    spring: spring ?? Springs.expressiveDefaultSpatial,
  );

  return .lerp(
    MaterialShapeBorder(shape: first),
    MaterialShapeBorder(shape: second),
    progress,
  )!;
}

(double, double, double, double) useValueSpring4D(
  (double, double, double, double) value, {
  SpringDescription? spring,
  bool animate = true,
}) {
  double use(double value) =>
      useValueSpring(value, spring: spring, animate: animate);

  return (use(value.$1), use(value.$2), use(value.$3), use(value.$4));
}

Color useColorSpring(
  Color value, {
  SpringDescription? spring,
  bool animate = true,
}) {
  final (a, r, g, b) = useValueSpring4D(
    (value.a, value.r, value.g, value.b),
    spring: spring,
    animate: animate,
  );

  return .from(alpha: a, red: r, green: g, blue: b);
}
