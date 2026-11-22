import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const AppCard({
  super.key,
  final VoidCallback? onTap,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Stack(
        children: [
          child,
          if (onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: AppInkWell(onTap: onTap),
              ),
            ),
        ],
      ),
    );
  }
}
