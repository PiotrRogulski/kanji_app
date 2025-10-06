import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:kanji_app/svg_drawing_animation/path_info.dart';

class SvgController {
  @internal
  SvgController({
    required this.pathInfo,
    required this.startDelay,
    required this.speed,
    required this.delayBetweenStrokes,
    required this.strokeAnimationCurve,
    required AnimationController animationController,
  }) : _controller = animationController,
       _strokeTimes = _calculateLengthTimes(pathInfo.partLengths, speed);

  final PathInfo pathInfo;
  final Duration startDelay;
  final double speed;
  final Duration delayBetweenStrokes;
  final Curve strokeAnimationCurve;

  final AnimationController _controller;
  final List<Duration> _strokeTimes;

  final _drawnStrokes = ValueNotifier<int?>(null);

  ValueListenable<int?> get drawnStrokes => _drawnStrokes;

  late final currentPathLengthLimit = PathLengthTween(
    partLengths: pathInfo.partLengths,
  ).animate(_controller);

  VoidCallback? _currentLoopCallback;

  var _animating = false;

  Future<void> nextStroke() async {
    if (_animating) {
      return;
    }

    if (_drawnStrokes.value == null ||
        _drawnStrokes.value == pathInfo.partLengths.length - 1) {
      _drawnStrokes.value = 0;
    } else {
      _drawnStrokes.value = _drawnStrokes.value! + 1;
    }

    try {
      _animating = true;
      final currentStroke = _drawnStrokes.value!;
      _controller.value = currentStroke.toDouble();
      await _controller.animateTo(
        _controller.value + 1,
        duration: _strokeTimes[currentStroke],
        curve: strokeAnimationCurve,
      );
    } finally {
      _animating = false;
    }
  }

  void cancel() {
    _currentLoopCallback?.call();
    _currentLoopCallback = null;
  }

  void loop() {
    if (_currentLoopCallback != null) {
      cancel();
    }

    var isCanceled = false;

    unawaited(
      Future(() async {
        _drawnStrokes.value = null;
        while (true) {
          if (_drawnStrokes.value == null ||
              _drawnStrokes.value == pathInfo.partLengths.length - 1) {
            await Future<void>.delayed(startDelay);
          } else {
            await Future<void>.delayed(delayBetweenStrokes);
          }
          if (isCanceled) {
            break;
          }
          await nextStroke();
        }
      }),
    );

    _currentLoopCallback = () {
      isCanceled = true;
      _controller.stop();
    };
  }

  void dispose() {
    cancel();
    _drawnStrokes.dispose();
  }
}

class PathLengthTween extends Animatable<double> {
  PathLengthTween({required this.partLengths});

  final List<double> partLengths;

  @override
  double transform(double t) {
    assert(t >= 0 && t <= partLengths.length);

    final partIndex = t.floor();

    final completedParts = partLengths.take(partIndex).sum;
    final currentPartLength =
        (partLengths.elementAtOrNull(partIndex) ?? 0) * (t - partIndex);

    return completedParts + currentPartLength;
  }
}

// Makes very short paths take only a slightly shorter time than longer paths.
List<Duration> _calculateLengthTimes(List<double> lengths, double speed) =>
    lengths
        .map((length) => sqrt(1000 + length * length))
        .map((length) => Duration(milliseconds: (length / speed).round()))
        .toList();
