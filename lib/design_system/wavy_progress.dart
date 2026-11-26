import 'dart:math';

import 'package:kanji_app/common/use_spring.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

/// The Material 3 Expressive wavy linear progress indicator. The sizes, the
/// colors and the speed are those of its reference implementation, Compose's
/// `LinearWavyProgressIndicator`.
class const AppWavyProgress({super.key, required final double value})
    extends HookWidget {
  static const _height = 10.0;

  // The wave is flat near both ends of the track.
  static const _wavyFrom = 0.1;
  static const _wavyTo = 0.95;

  // One wavelength a second.
  static const _wavePeriod = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final progress = useValueSpring(
      value,
      spring: Springs.expressiveDefaultSpatial,
    );
    final waviness = useValueSpring(
      value > _wavyFrom && value < _wavyTo ? 1 : 0,
    );

    final flow = useAnimationController(duration: _wavePeriod);
    useEffect(() {
      flow.repeat();
      return null;
    }, [flow]);

    return Semantics(
      value: '${(value * 100).round()}%',
      child: RepaintBoundary(
        child: CustomPaint(
          size: const .new(.infinity, _height),
          painter: _WavyProgressPainter(
            progress: progress.clamp(0, 1),
            waviness: waviness.clamp(0, 1),
            flow: flow,
            activeColor: colorScheme.primary,
            trackColor: colorScheme.secondaryContainer,
          ),
        ),
      ),
    );
  }
}

class const _WavyProgressPainter({
  required final double progress,
  required final double waviness,
  required final Animation<double> flow,
  required final Color activeColor,
  required final Color trackColor,
}) extends CustomPainter {
  this : super(repaint: flow);

  static const _thickness = 4.0;
  static const _wavelength = 40.0;
  static const _amplitude = 3.0;
  static const _gap = 4.0;
  static const _stopSize = 4.0;
  static const _step = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    const start = _thickness / 2;
    final end = size.width - _thickness / 2;
    final activeEnd = start + (end - start) * progress;

    final paint = Paint()
      ..style = .stroke
      ..strokeWidth = _thickness
      ..strokeCap = .round;

    final trackStart = activeEnd + _gap + _thickness;
    if (trackStart < end) {
      canvas.drawLine(
        .new(trackStart, centerY),
        .new(end, centerY),
        paint..color = trackColor,
      );
    }

    canvas.drawCircle(
      .new(size.width - _stopSize / 2, centerY),
      _stopSize / 2,
      Paint()..color = activeColor,
    );

    final amplitude = _amplitude * waviness;
    final phase = flow.value * 2 * pi;

    double waveY(double x) =>
        centerY + amplitude * sin(x / _wavelength * 2 * pi - phase);

    final wave = Path()..moveTo(start, waveY(start));
    for (var x = start + _step; x < activeEnd; x += _step) {
      wave.lineTo(x, waveY(x));
    }
    wave.lineTo(activeEnd, waveY(activeEnd));

    canvas.drawPath(
      wave,
      paint
        ..color = activeColor
        ..strokeJoin = .round,
    );
  }

  @override
  bool shouldRepaint(_WavyProgressPainter old) =>
      old.progress != progress ||
      old.waviness != waviness ||
      old.flow != flow ||
      old.activeColor != activeColor ||
      old.trackColor != trackColor;
}
