import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension type const AppUnit._(double value) implements double {
  /// A value of 2.0.
  static const tiny = AppUnit._(2);

  /// A value of 4.0.
  static const xsmall = AppUnit._(4);

  /// A value of 8.0.
  static const small = AppUnit._(8);

  /// A value of 12.0.
  static const medium = AppUnit._(12);

  /// A value of 16.0.
  static const large = AppUnit._(16);

  /// A value of 28.0.
  static const xlarge = AppUnit._(28);

  Widget get gap => Gap(value);

  Widget get sliverGap => SliverGap(value);
}
