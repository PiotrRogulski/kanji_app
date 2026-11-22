import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const AppPadding({
  super.key,
  required AppEdgeInsets super.padding,
  super.child,
}) extends Padding;

class const AppSliverPadding({
  super.key,
  required AppEdgeInsets super.padding,
  super.sliver,
}) extends SliverPadding;

class AppEdgeInsets extends EdgeInsetsDirectional {
  const new all(AppUnit super.value) : super.all();

  const new only({
    AppUnit super.start = .zero,
    AppUnit super.top = .zero,
    AppUnit super.end = .zero,
    AppUnit super.bottom = .zero,
  }) : super.only();

  const new symmetric({
    AppUnit super.horizontal = .zero,
    AppUnit super.vertical = .zero,
  }) : super.symmetric();

  static const zero = AppEdgeInsets.only();
}
