import 'dart:math';

import 'package:kanji_app/design_system/motion.dart';
import 'package:kanji_app/features/details/widgets/radical_glyph.dart';
import 'package:material_ui/material_ui.dart';

class const RadicalHero({
  required final int kanjiId,
  required final String form,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  static const openSpring = Springs.expressiveFastSpatial;
  static const closeSpring = Springs.expressiveDefaultSpatial;

  // How long the dialog's route lasts. Each has to outlast its spring.
  static const openDuration = Duration(milliseconds: 500);
  static const closeDuration = Duration(milliseconds: 450);

  static const _openCurve = SpringCurve(openSpring, openDuration);
  static const _closeCurve = SpringCurve(closeSpring, closeDuration);

  // A quarter turn, as the chip's square looks the same after one.
  static const _flightAngle = -pi / 2;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'kanjiRadical-$kanjiId',
      curve: _openCurve,
      reverseCurve: _closeCurve.flipped,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      flightShuttleBuilder: (flightContext, animation, _, _, _) {
        final theme = Theme.of(flightContext);
        final chip = RadicalGlyph.chip(form, theme);
        final badge = RadicalGlyph.badge(form, theme);

        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final progress = animation.value;

            return RadicalGlyph(
              form,
              shape: ShapeBorder.lerp(chip.shape, badge.shape, progress)!,
              color: Color.lerp(chip.color, badge.color, progress)!,
              foregroundColor: Color.lerp(
                chip.foregroundColor,
                badge.foregroundColor,
                progress,
              )!,
              shapeAngle: (1 - progress) * _flightAngle,
            );
          },
        );
      },
      child: child,
    );
  }
}
