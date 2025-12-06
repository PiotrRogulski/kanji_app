import 'package:flutter/physics.dart';

const dismissDistance = 150.0;
const minVelocity = 800.0;
final spring = SpringDescription.withDampingRatio(
  mass: 1,
  stiffness: 800,
  ratio: 0.5,
);
