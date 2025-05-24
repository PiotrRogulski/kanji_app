import 'package:flutter/material.dart' hide ErrorWidgetBuilder;
import 'package:kanji_app/svg_drawing_animation/clipped_path_painter.dart';
import 'package:kanji_app/svg_drawing_animation/pen.dart';
import 'package:kanji_app/svg_drawing_animation/svg_controller.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class SvgDrawingAnimation extends HookWidget {
  const SvgDrawingAnimation({
    super.key,
    required this.controller,
    required this.strokePaint,
    this.pen,
  });

  final SvgController controller;
  final Paint strokePaint;
  final Pen? pen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final pathLengthLimit = useAnimation(controller.currentPathLengthLimit);
    final drawnStrokes = useValueListenable(controller.drawnStrokes);

    final size = controller.pathInfo.size;

    return FittedBox(
      child: Container(
        width: size.longestSide,
        height: size.longestSide,
        alignment: Alignment.center,
        child: Stack(
          children: [
            CustomPaint(
              size: controller.pathInfo.size,
              painter: ClippedPathPainter(
                controller.pathInfo.paths,
                pathLengthLimit: double.infinity,
                strokePaint: Paint.from(strokePaint)
                  ..color = colorScheme.outlineVariant,
              ),
            ),
            CustomPaint(
              size: controller.pathInfo.size,
              painter: ClippedPathPainter(
                controller.pathInfo.paths.take((drawnStrokes ?? -1) + 1),
                pathLengthLimit: pathLengthLimit,
                strokePaint: strokePaint,
                pen: pen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
