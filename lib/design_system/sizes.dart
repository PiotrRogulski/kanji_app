import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meta/meta.dart';

extension type const AppUnit._(double _value) implements double {
  /// A value of 0.0.
  static const zero = AppUnit._(0);

  /// A value of 2.0.
  static const tiny = AppUnit._(2);

  /// A value of 4.0.
  static const xsmall = AppUnit._(4);

  /// A value of 8.0.
  static const small = AppUnit._(8);

  /// A value of 16.0.
  static const medium = AppUnit._(16);

  /// A value of 24.0.
  static const large = AppUnit._(24);

  /// A value of 32.0.
  static const xlarge = AppUnit._(32);

  Widget get gap => Gap(_value);

  Widget get sliverGap => SliverGap(_value);

  @redeclare
  AppUnit operator *(double factor) => ._(_value * factor);

  @redeclare
  AppUnit operator +(AppUnit other) => ._(_value + other._value);
}
