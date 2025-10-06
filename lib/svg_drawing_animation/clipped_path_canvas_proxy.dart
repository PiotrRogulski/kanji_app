import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/svg_drawing_animation/pen.dart';

class ClippedPathCanvasProxy implements Canvas {
  ClippedPathCanvasProxy(
    this.canvas, {
    required this.pathLengthLimit,
    this.pen,
  });

  final Canvas canvas;
  final double pathLengthLimit;
  final Pen? pen;

  double _drawnPathLength = 0;

  @override
  void drawPath(Path path, Paint paint) {
    for (final contourMetrics in path.computeMetrics()) {
      // Compute how much we're allowed to draw.
      final lengthToDraw = min(
        pathLengthLimit - _drawnPathLength,
        contourMetrics.length,
      );

      // If we can't draw anymore, abort.
      if (lengthToDraw == 0) {
        break;
      }

      // Pass-through draw.
      final pathToDraw = contourMetrics.extractPath(0, lengthToDraw);
      canvas.drawPath(pathToDraw, paint);
      _drawnPathLength += lengthToDraw;

      // If we drew less than the full contour length, it means we've reached
      // [pathLengthLimit] and the end of the current contour is where the "pen"
      // is.
      if (pen case Pen(:final radius, :final paint)) {
        final isFinalStroke =
            (lengthToDraw - contourMetrics.length).abs() > 1e-4;
        if (isFinalStroke) {
          final pathEndPoint = contourMetrics.extractPath(
            lengthToDraw,
            lengthToDraw,
          );
          final penPosition = pathEndPoint.getBounds().center;
          // Render the pen's tip.
          canvas.drawCircle(penPosition, radius, paint);
        }
      }
    }
  }

  @override
  void transform(Float64List matrix4) => canvas.transform(matrix4);

  @override
  Float64List getTransform() => canvas.getTransform();

  @override
  void save() => canvas.save();

  @override
  void restore() => canvas.restore();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Ignore missing implementations.
    // super.noSuchMethod(invocation);
  }
}
