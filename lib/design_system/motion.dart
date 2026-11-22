import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// The spring used when a call site doesn't pick one. It doesn't overshoot, so
/// it's safe for values that are clamped or asserted to a range, such as
/// opacity, colors, sizes or factors animating to 0.
const defaultSpring = Springs.expressiveDefaultEffects;

/// The path [spring] takes from rest at 0 to 1, overshoot included.
/// [duration] has to be long enough for the spring to settle.
final class const SpringCurve(
  final SpringDescription spring,
  final Duration duration,
) extends Curve {
  @override
  double transformInternal(double t) => SpringSimulation(
    spring,
    0,
    1,
    0,
  ).x(t * duration.inMicroseconds / Duration.microsecondsPerSecond);
}

extension AnimationControllerSpring on AnimationController {
  /// Animates from the current value to [target] along [spring], which falls
  /// back to [defaultSpring].
  TickerFuture springTo(
    double target, {
    SpringDescription? spring,
    double velocity = 0,
    bool snapToEnd = false,
  }) => animateWith(
    SpringSimulation(
      spring ?? defaultSpring,
      value,
      target,
      velocity,
      snapToEnd: snapToEnd,
    ),
  );
}

extension ScrollControllerSpring on ScrollController {
  /// The spring each position was last sent on, to continue from its velocity.
  /// Once another activity replaces it, it's disposed and its velocity is 0.
  static final _springs = Expando<_SpringScrollActivity>();

  /// Scrolls to [offset] along a spring. If the previous spring is still
  /// running, it continues from its velocity, so repeated calls keep their
  /// momentum. Touching the scroll view stops it, like a fling.
  ///
  /// The spring doesn't overshoot, because the scroll position is clamped at
  /// its extents.
  ///
  /// Requires the default [ScrollPositionWithSingleContext].
  void springTo(double offset) {
    final position = this.position as ScrollPositionWithSingleContext;
    final spring = _SpringScrollActivity(
      position,
      ScrollSpringSimulation(
        Springs.expressiveSlowEffects,
        position.pixels,
        offset,
        _springs[position]?.velocity ?? 0,
        tolerance: position.physics.toleranceFor(position),
      ),
      position.context.vsync,
      true,
    );

    _springs[position] = spring;
    position.beginActivity(spring);
  }
}

/// A ballistic activity that keeps heading for its spring's target.
///
/// [BallisticScrollActivity] hands its velocity over to the scroll physics
/// whenever the scroll view's dimensions change, which happens all the time in
/// lazy lists, as their estimated extent gets corrected. That turns the spring
/// into a fling, which overshoots the target by far.
final class _SpringScrollActivity(
  super.delegate,
  super.simulation,
  super.vsync,
  super.shouldIgnorePointer,
) extends BallisticScrollActivity {
  @override
  void applyNewDimensions() {}
}
