import 'package:flutter/material.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class JDSearchBar extends HookWidget {
  const JDSearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.autoFocus = false,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final searchEmpty = useListenableSelector(
      controller,
      () => controller.text.isEmpty,
    );

    final progress = useValueSpring(searchEmpty ? 0 : 1, stiffness: 1000);

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
