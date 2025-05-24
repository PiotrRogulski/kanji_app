import 'package:flutter/material.dart';
import 'package:kanji_app/svg_drawing_animation/clipped_path_canvas_proxy.dart';
import 'package:kanji_app/svg_drawing_animation/pen.dart';

class ClippedPathPainter extends CustomPainter {
  ClippedPathPainter(
    this.paths, {
    required this.pathLengthLimit,
    required this.strokePaint,
    this.pen,
  });

  final Iterable<Path> paths;
  final double pathLengthLimit;
  final Paint strokePaint;
  final Pen? pen;

  @override
  void paint(Canvas canvas, Size size) {
    final proxy = ClippedPathCanvasProxy(
      canvas,
      pathLengthLimit: pathLengthLimit,
      pen: pen,
    );
    for (final path in paths) {
      proxy.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(ClippedPathPainter oldDelegate) {
    return paths != oldDelegate.paths ||
        pathLengthLimit != oldDelegate.pathLengthLimit ||
        strokePaint != oldDelegate.strokePaint ||
        pen != oldDelegate.pen;
  }
}
