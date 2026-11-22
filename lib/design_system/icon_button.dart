import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const AppIconButton({
  super.key,
  required final AppIconData icon,
  required final AppUnit iconSize,
  final VoidCallback? onPressed,
  final Color? color,
  final double? fill,
  final AppEdgeInsets? iconPadding,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: .transparency,
      shape: const CircleBorder(),
      clipBehavior: .antiAlias,
      child: AppInkWell(
        onTap: onPressed,
        child: AppPadding(
          padding: iconPadding ?? const .all(.small),
          child: AppIcon(icon, size: iconSize, color: color, fill: fill),
        ),
      ),
    );
  }
}
