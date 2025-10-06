import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_shapes/material_shapes.dart';

enum SpringState {
  first(value: 0, ratio: 1),
  second(value: 1, ratio: 0.4);

  const SpringState({required this.value, required this.ratio});

  final double value;
  final double ratio;
}

SpringDescription _spring({required double ratio, required double stiffness}) =>
    .withDampingRatio(mass: 1, stiffness: stiffness, ratio: ratio);

double useValueSpring(
  double value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  final controller = useUnboundedAnimationController(initialValue: value);
  useValueChanged<(double, bool), void>((value, animate), (_, _) {
    if (animate) {
      controller.animateWith(
        SpringSimulation(
          _spring(ratio: ratio ?? 1, stiffness: stiffness ?? 500),
          controller.value,
          value,
          0,
        ),
      );
    } else {
      controller.value = value;
    }
  });

  return useAnimation(controller);
}

Path useShapeSpring({
  required RoundedPolygon first,
  required RoundedPolygon second,
  required SpringState state,
}) {
  final animatable = useMemoized(() => _MorphPath(first, second), [
    first,
    second,
  ]);

  final progress = useValueSpring(state.value, ratio: state.ratio);

  return animatable.transform(progress);
}

class _MorphPath extends Animatable<Path> {
  _MorphPath(RoundedPolygon first, RoundedPolygon second)
    : morph = .new(first, second);

  final Morph morph;

  @override
  Path transform(double t) => morph.toPath(progress: t);
}

(double, double, double, double) useValueSpring4D(
  (double, double, double, double) value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  return (
    useValueSpring(
      value.$1,
      ratio: ratio,
      stiffness: stiffness,
      animate: animate,
    ),
    useValueSpring(
      value.$2,
      ratio: ratio,
      stiffness: stiffness,
      animate: animate,
    ),
    useValueSpring(
      value.$3,
      ratio: ratio,
      stiffness: stiffness,
      animate: animate,
    ),
    useValueSpring(
      value.$4,
      ratio: ratio,
      stiffness: stiffness,
      animate: animate,
    ),
  );
}

Color useColorSpring(
  Color value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  final (a, r, g, b) = useValueSpring4D(
    (value.a, value.r, value.g, value.b),
    ratio: ratio,
    stiffness: stiffness,
    animate: animate,
  );

  return .from(alpha: a, red: r, green: g, blue: b);
}
