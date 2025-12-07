import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class KanjiGridPainter extends CustomPainter {
  KanjiGridPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.longestSide;

    final unit = side / 100;
    final color = colorScheme.outlineVariant;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = unit
      ..style = .stroke;
    final dashedLinePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = unit / 2
      ..style = .stroke;
    final dashLength = unit * 4;
    final gapLength = unit * 2;

    void drawDashedLine(Offset p1, Offset p2) {
      final delta = p2 - p1;
      final totalLength = delta.distance;

      final direction = delta / totalLength;

      var distanceTraveled = 0.0;
      while (distanceTraveled < totalLength) {
        final start = p1 + direction * distanceTraveled;
        final endDistance = (distanceTraveled + dashLength).clamp(
          0,
          totalLength,
        );
        final end = p1 + direction * endDistance.toDouble();
        canvas.drawLine(start, end, dashedLinePaint);
        distanceTraveled += dashLength + gapLength;
      }
    }

    const radius = Radius.circular(AppUnit.xlarge);
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, radius);
    canvas
      ..drawRRect(rrect, Paint()..color = colorScheme.surfaceContainerLowest)
      ..drawRRect(rrect, borderPaint);

    drawDashedLine(rect.centerLeft, rect.centerRight);
    drawDashedLine(rect.topCenter, rect.bottomCenter);
  }

  @override
  bool shouldRepaint(KanjiGridPainter oldDelegate) =>
      colorScheme != oldDelegate.colorScheme;
}
