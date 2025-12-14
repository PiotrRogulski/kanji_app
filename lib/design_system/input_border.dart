import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class AppInputBorder extends InputBorder {
  const AppInputBorder({
    super.borderSide,
    this.borderRadius = .medium,
    this.gapPadding = .xsmall,
  });

  final AppUnit borderRadius;

  final AppUnit gapPadding;

  @override
  bool get isOutline => true;

  @override
  AppInputBorder copyWith({
    BorderSide? borderSide,
    AppUnit? borderRadius,
    AppUnit? gapPadding,
  }) => .new(
    borderSide: borderSide ?? this.borderSide,
    borderRadius: borderRadius ?? this.borderRadius,
    gapPadding: gapPadding ?? this.gapPadding,
  );

  @override
  EdgeInsetsGeometry get dimensions => .all(borderSide.width);

  @override
  AppInputBorder scale(double t) => .new(
    borderSide: borderSide.scale(t),
    borderRadius: borderRadius * t,
    gapPadding: gapPadding * t,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a case final AppInputBorder other) {
      return AppInputBorder(
        borderSide: .lerp(other.borderSide, borderSide, t),
        borderRadius: .lerp(other.borderRadius, borderRadius, t),
        gapPadding: .lerp(other.gapPadding, gapPadding, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b case final AppInputBorder other) {
      return AppInputBorder(
        borderSide: .lerp(borderSide, other.borderSide, t),
        borderRadius: .lerp(borderRadius, other.borderRadius, t),
        gapPadding: .lerp(gapPadding, other.gapPadding, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => .new()
    ..addRRect(.fromRectAndRadius(rect, .circular(borderRadius)).deflate(0));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => .new()
    ..addRRect(.fromRectAndRadius(rect, .circular(borderRadius)).deflate(0));

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(.fromRectAndRadius(rect, .circular(borderRadius)), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);

    final paint = borderSide.toPaint()..strokeCap = .round;
    final outer = RRect.fromRectAndRadius(rect, .circular(borderRadius));
    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawRRect(outer, paint);
    } else {
      final extent = lerpDouble(
        0.0,
        gapExtent + gapPadding * 2.0,
        gapPercentage,
      )!;
      final start = switch (textDirection!) {
        .rtl => gapStart + gapPadding - extent,
        .ltr => gapStart - gapPadding,
      };
      final path = _gapBorderPath(
        canvas,
        outer,
        outer.width,
        max(0, start),
        extent,
      );
      canvas.drawPath(path, paint);
    }
  }

  Path _gapBorderPath(
    Canvas canvas,
    RRect center,
    double outerWidth,
    double start,
    double extent,
  ) {
    final scaledRRect = center.scaleRadii();

    final tlCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.top,
      scaledRRect.tlRadiusX * 2.0,
      scaledRRect.tlRadiusY * 2.0,
    );
    final trCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.trRadiusX * 2.0,
      scaledRRect.top,
      scaledRRect.trRadiusX * 2.0,
      scaledRRect.trRadiusY * 2.0,
    );
    final brCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.brRadiusX * 2.0,
      scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
      scaledRRect.brRadiusX * 2.0,
      scaledRRect.brRadiusY * 2.0,
    );
    final blCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
      scaledRRect.blRadiusX * 2.0,
      scaledRRect.blRadiusY * 2.0,
    );

    const cornerArcSweep = pi / 2.0;
    final path = Path();

    if (scaledRRect.tlRadius != Radius.zero) {
      final tlCornerArcSweep = acos(
        clampDouble(1 - start / scaledRRect.tlRadiusX, 0, 1),
      );
      path.addArc(tlCorner, pi, tlCornerArcSweep);
    } else {
      path.moveTo(scaledRRect.left - borderSide.width / 2, scaledRRect.top);
    }

    if (start > scaledRRect.tlRadiusX) {
      path.lineTo(start, scaledRRect.top);
    }

    const trCornerArcStart = (3 * pi) / 2.0;
    const trCornerArcSweep = cornerArcSweep;
    if (start + extent < outerWidth - scaledRRect.trRadiusX) {
      path
        ..moveTo(start + extent, scaledRRect.top)
        ..lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top);
      if (scaledRRect.trRadius != .zero) {
        path.addArc(trCorner, trCornerArcStart, trCornerArcSweep);
      }
    } else if (start + extent < outerWidth) {
      final dx = outerWidth - (start + extent);
      final sweep = asin(clampDouble(1 - dx / scaledRRect.trRadiusX, 0, 1));
      path.addArc(trCorner, trCornerArcStart + sweep, trCornerArcSweep - sweep);
    }

    if (scaledRRect.brRadius != .zero) {
      path.moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY);
    }
    path.lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY);
    if (scaledRRect.brRadius != .zero) {
      path.addArc(brCorner, 0, cornerArcSweep);
    }

    path.lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom);
    if (scaledRRect.blRadius != .zero) {
      path.addArc(blCorner, pi / 2.0, cornerArcSweep);
    }

    path.lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);

    return path;
  }
}
