import 'dart:ui';

import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const StadiumMorphBorder({
  required final AppUnit fixedCornerRadius,
  required final double stadiumProgress,
}) extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => .zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      .new()..addRRect(
        .fromRectAndRadius(
          rect,
          .circular(
            lerpDouble(fixedCornerRadius, rect.height / 2, stadiumProgress)!,
          ),
        ),
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  StadiumMorphBorder scale(double t) => .new(
    fixedCornerRadius: fixedCornerRadius * t,
    stadiumProgress: stadiumProgress,
  );
}
