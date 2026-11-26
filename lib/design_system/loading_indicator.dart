import 'dart:math';

import 'package:kanji_app/design_system/motion.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

/// The Material 3 Expressive loading indicator. The shapes, the timing and the
/// proportions are those of its reference implementation, Compose's
/// `LoadingIndicator`.
class const AppLoadingIndicator({
  super.key,
  final double size = 48,
  final Color? color,
}) extends HookWidget {
  static const _morphInterval = Duration(milliseconds: 650);
  static const _rotationPeriod = Duration(milliseconds: 4666);
  static const _morphTurn = pi / 2;

  // The shape is 38 in a container of 48.
  static const _activeScale = 38 / 48;

  static final _morphCurve = SpringCurve(
    .withDampingRatio(mass: 1, stiffness: 200, ratio: 0.6),
    _morphInterval,
  );

  static final _shapes = [
    for (final shape in [
      MaterialShapes.softBurst,
      MaterialShapes.cookie9Sided,
      MaterialShapes.pentagon,
      MaterialShapes.pill,
      MaterialShapes.sunny,
      MaterialShapes.cookie4Sided,
      MaterialShapes.oval,
    ])
      MaterialShapeBorder(shape: shape),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final morphs = useAnimationController(
      duration: _morphInterval * _shapes.length,
    );
    final rotation = useAnimationController(duration: _rotationPeriod);
    useEffect(() {
      morphs.repeat();
      rotation.repeat();
      return null;
    }, [morphs, rotation]);

    final time = useAnimation(morphs) * _shapes.length;
    final index = time.floor() % _shapes.length;
    final morph = _morphCurve.transform(time - time.floor());
    final turn = useAnimation(rotation) * 2 * pi;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: SizedBox.square(
            dimension: size * _activeScale,
            child: Transform.rotate(
              angle: (index + morph) * _morphTurn + turn,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color ?? colorScheme.primary,
                  shape: ShapeBorder.lerp(
                    _shapes[index],
                    _shapes[(index + 1) % _shapes.length],
                    // The spring overshoots, but a morph can't.
                    morph.clamp(0, 1),
                  )!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
