import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

const appLiquidGlassSettings = LiquidGlassSettings(
  frost: 4,
  refractionAmount: 80,
  refractionFitsShape: false,
);

LiquidGlassAppearance appGlassAppearanceOf(BuildContext context) => .new(
  tint: Theme.of(context).colorScheme.surfaceBright.withValues(alpha: 0.25),
);

const appLiquidGlassShadows = [
  BoxShadow(color: .new(0x1F000000), offset: .new(0, 6), blurRadius: 20),
];

class const AppGlassLayer({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      settings: appLiquidGlassSettings,
      defaultAppearance: appGlassAppearanceOf(context),
      child: child,
    );
  }
}

class const AppGlassIconButton({
  super.key,
  required final AppIconData icon,
  final VoidCallback? onPressed,
  final String? tooltip,
}) extends StatelessWidget {
  static const size = 48.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: DynamicWeight(
        child: _GlassIconButton(icon: icon, onPressed: onPressed),
      ),
    );
  }
}

class const _GlassIconButton({
  required final AppIconData icon,
  required final VoidCallback? onPressed,
}) extends HookWidget {
  static const _pressedScale = 1.15;

  @override
  Widget build(BuildContext context) {
    final pressed = DynamicWeight.of(context).pressed;
    final scale = useValueSpring(
      pressed ? _pressedScale : 1,
      spring: Springs.expressiveFastSpatial,
    );

    return Transform.scale(
      scale: scale,
      child: LiquidGlass.auto(
        shape: const LiquidOval(),
        settings: appLiquidGlassSettings,
        appearance: appGlassAppearanceOf(context),
        shadows: appLiquidGlassShadows,
        child: SizedBox.square(
          dimension: AppGlassIconButton.size,
          child: AppIconButton(
            icon: icon,
            iconSize: .large,
            iconPadding: .all(AppUnit.small + AppUnit.xsmall),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
