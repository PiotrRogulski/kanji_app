import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class StadiumMorphBorder extends ShapeBorder {
  const StadiumMorphBorder({
    required this.fixedCornerRadius,
    required this.stadiumProgress,
  });

  final AppUnit fixedCornerRadius;
  final double stadiumProgress;

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
