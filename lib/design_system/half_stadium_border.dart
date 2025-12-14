import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class HalfStadiumBorder extends ShapeBorder {
  const HalfStadiumBorder({this.startRadius, this.endRadius});

  final AppUnit? startRadius;
  final AppUnit? endRadius;

  @override
  EdgeInsetsGeometry get dimensions => .zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return .new()..addRRect(
      BorderRadiusDirectional.horizontal(
        start: .circular(startRadius ?? rect.height / 2),
        end: .circular(endRadius ?? rect.height / 2),
      ).resolve(textDirection).toRRect(rect),
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  HalfStadiumBorder scale(double t) => .new(
    startRadius: startRadius != null ? startRadius! * t : null,
    endRadius: endRadius != null ? endRadius! * t : null,
  );
}
