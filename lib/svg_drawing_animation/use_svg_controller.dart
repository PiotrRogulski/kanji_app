import 'package:flutter/animation.dart';
import 'package:kanji_app/svg_drawing_animation/path_info.dart';
import 'package:kanji_app/svg_drawing_animation/svg_controller.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

SvgController useSvgController(
  String svg, {
  required Duration startDelay,
  required double speed,
  required Duration delayBetweenStrokes,
  required Curve strokeAnimationCurve,
}) {
  final pathInfo = useMemoized(() => pathInfoFromSvg(svg), [svg]);

  final animationController = useAnimationController(
    upperBound: pathInfo.partLengths.length.toDouble(),
  );

  final controller = useMemoized(
    () => SvgController(
      pathInfo: pathInfo,
      startDelay: startDelay,
      speed: speed,
      delayBetweenStrokes: delayBetweenStrokes,
      strokeAnimationCurve: strokeAnimationCurve,
      animationController: animationController,
    ),
    [pathInfo, startDelay, speed, delayBetweenStrokes, strokeAnimationCurve],
  );

  useEffect(() => controller.dispose, [controller]);

  return controller;
}
