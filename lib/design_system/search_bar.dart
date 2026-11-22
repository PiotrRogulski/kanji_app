import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const JDSearchBar({
  super.key,
  required final TextEditingController controller,
  final ValueChanged<String>? onSubmitted,
  final bool autoFocus = false,
  final String? hintText,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final searchEmpty = useListenableSelector(
      controller,
      () => controller.text.isEmpty,
    );

    final progress = useValueSpring(
      searchEmpty ? 0 : 1,
      spring: Springs.expressiveSlowEffects,
    );

    return Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: controller,
            trailing: [
              Center(
                widthFactor: progress,
                child: Opacity(
                  opacity: progress,
                  child: AppPadding(
                    padding: const .only(start: .small),
                    child: AppIconButton(
                      icon: .clear,
                      iconSize: .large,
                      onPressed: controller.clear,
                    ),
                  ),
                ),
              ),
            ],
            hintText: hintText ?? s.common_search,
            onSubmitted: onSubmitted,
            autoFocus: autoFocus,
          ),
        ),
        if (onSubmitted case final onSubmitted?)
          Center(
            widthFactor: progress,
            child: Opacity(
              opacity: progress,
              child: AppPadding(
                padding: const .only(start: .small),
                child: AppIconButton(
                  icon: .search,
                  iconSize: .large,
                  onPressed: () => onSubmitted(controller.text),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
