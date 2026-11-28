import 'package:material_ui/material_ui.dart';

class const RadicalGlyph(
  final String form, {
  required final ShapeBorder shape,
  required final Color color,
  required final Color foregroundColor,
  final double shapeAngle = 0,
  super.key,
}) extends StatelessWidget {
  new chip(String form, ThemeData theme, {Key? key})
    : this(
        form,
        shape: _chipShape,
        color: theme.colorScheme.surfaceBright,
        foregroundColor: theme.colorScheme.onSurface,
        key: key,
      );

  new badge(String form, ThemeData theme, {Key? key})
    : this(
        form,
        shape: _badgeShape,
        color: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        key: key,
      );

  static final _chipShape = MaterialShapeBorder(shape: MaterialShapes.square);
  static final _badgeShape = MaterialShapeBorder(
    shape: MaterialShapes.cookie9Sided,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: .expand,
      children: [
        Transform.rotate(
          angle: shapeAngle,
          child: DecoratedBox(
            decoration: ShapeDecoration(shape: shape, color: color),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.56,
          heightFactor: 0.56,
          child: FittedBox(
            child: Text(
              form,
              style: theme.textTheme.displayLarge?.copyWith(
                color: foregroundColor,
                height: 1,
                decoration: .none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
