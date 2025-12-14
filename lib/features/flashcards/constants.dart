import 'dart:math';
import 'dart:ui';

import 'package:flutter/physics.dart';

const dismissDistance = 150.0;
const minVelocity = 800.0;
final spring = SpringDescription.withDampingRatio(
  mass: 1,
  stiffness: 800,
  ratio: 0.5,
);

const flashcardWidthMin = 280.0;
const flashcardWidthMax = 600.0;
const flashcardHeightMin = 260.0;
const flashcardHeightMax = 1600.0;

const flashcardKanjiFontSize = 140.0;
const flashcardWordFontSize = 80.0;

enum FlashcardDismissAction { learned, skipped }

extension FlashcardDismissOffsetExtension on Offset {
  double get dismissProgress =>
      min(distance, dismissDistance) / dismissDistance;
}
