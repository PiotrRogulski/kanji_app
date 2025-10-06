import 'package:flutter/animation.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

AnimationController useUnboundedAnimationController({
  Duration? duration,
  Duration? reverseDuration,
  String? debugLabel,
  double initialValue = 0,
  TickerProvider? vsync,
  AnimationBehavior animationBehavior = .normal,
  List<Object?>? keys,
}) {
  return useAnimationController(
    duration: duration,
    reverseDuration: reverseDuration,
    debugLabel: debugLabel,
    initialValue: initialValue,
    lowerBound: .negativeInfinity,
    upperBound: .infinity,
    vsync: vsync,
    animationBehavior: animationBehavior,
  );
}
