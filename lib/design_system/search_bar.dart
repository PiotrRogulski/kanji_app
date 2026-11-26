import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/extensions.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_ui/material_ui.dart';

class const JDSearchBar({
  super.key,
  required final TextEditingController controller,
  final ValueChanged<String>? onSubmitted,
  final bool autoFocus = false,
  final String? hintText,
}) extends StatelessWidget {
  static const height = 56.0;

  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: _SearchBar(
        controller: controller,
        onSubmitted: onSubmitted,
        autoFocus: autoFocus,
        hintText: hintText,
      ),
    );
  }
}

class const _SearchBar({
  required final TextEditingController controller,
  required final ValueChanged<String>? onSubmitted,
  required final bool autoFocus,
  required final String? hintText,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.bodyLarge!;

    final dynamicWeight = DynamicWeight.of(context);
    final focused = dynamicWeight.focused;

    final iconColor = useColorSpring(
      focused ? colorScheme.primary : colorScheme.onSurfaceVariant,
    );
    final textWeight = useValueSpring(
      (focused ? AppDynamicWeight.regular : dynamicWeight.weight).value,
    );
    final dynamicTextStyle = textStyle.copyWith(
      fontVariations: [
        .weight(textWeight),
        if (textStyle.fontSize case final size?) .opticalSize(size),
      ],
    );

    final searchEmpty = useListenableSelector(
      controller,
      () => controller.text.isEmpty,
    );

    final progress = useValueSpring(
      searchEmpty ? 0 : 1,
      spring: Springs.expressiveSlowEffects,
    );

    return AppGlassLayer(
      child: LiquidGlass(
        shape: const LiquidRoundedSuperellipse(
          borderRadius: JDSearchBar.height / 2,
        ),
        shadows: appLiquidGlassShadows,
        child: Material(
          type: .transparency,
          child: SizedBox(
            height: JDSearchBar.height,
            child: Row(
              children: [
                AppUnit.medium.gap,
                AppIcon(.search, size: .large, color: iconColor),
                AppUnit.small.gap,
                Expanded(
                  child: TextField(
                    controller: controller,
                    statesController: dynamicWeight.controller,
                    autofocus: autoFocus,
                    onSubmitted: onSubmitted,
                    textInputAction: .search,
                    style: dynamicTextStyle,
                    decoration: .collapsed(
                      hintText: hintText ?? s.common_search,
                      hintStyle: dynamicTextStyle.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Center(
                  widthFactor: progress,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: DynamicWeight(
                        child: AppIconButton(
                          icon: .clear,
                          iconSize: .large,
                          onPressed: controller.clear,
                        ),
                      ),
                    ),
                  ),
                ),
                if (onSubmitted case final onSubmitted?)
                  Center(
                    widthFactor: progress,
                    child: Opacity(
                      opacity: progress,
                      child: DynamicWeight(
                        child: AppIconButton(
                          icon: .search,
                          iconSize: .large,
                          onPressed: () => onSubmitted(controller.text),
                        ),
                      ),
                    ),
                  ),
                AppUnit.small.gap,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
