import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const AppInkWell({
  super.key,
  final GestureTapCallback? onTap,
  final Color? focusColor,
  final Color? hoverColor,
  final Color? highlightColor,
  final Color? splashColor,
  final AppBorderRadius? borderRadius,
  final Widget? child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      statesController: DynamicWeight.maybeOf(context)?.controller,
      onTap: onTap,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      borderRadius: borderRadius?.resolve(Directionality.of(context)),
      child: child,
    );
  }
}
