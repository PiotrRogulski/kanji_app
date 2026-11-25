import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class AppBorderRadius extends BorderRadiusDirectional {
  new circular(AppUnit super.radius) : super.circular();

  new vertical({AppUnit top = .zero, AppUnit bottom = .zero})
    : super.vertical(top: .circular(top), bottom: .circular(bottom));

  new horizontal({AppUnit start = .zero, AppUnit end = .zero})
    : super.horizontal(start: .circular(start), end: .circular(end));

  const new _only({
    super.topStart,
    super.topEnd,
    super.bottomStart,
    super.bottomEnd,
  }) : super.only();

  @override
  AppBorderRadius operator *(double other) => ._only(
    topStart: topStart * other,
    topEnd: topEnd * other,
    bottomStart: bottomStart * other,
    bottomEnd: bottomEnd * other,
  );
}
