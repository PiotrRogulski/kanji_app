import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';

class GroupedKanjiRow extends StatelessWidget {
  const GroupedKanjiRow({
    super.key,
    this.onItemTapHandlerGetter,
    required this.label,
    required this.items,
  });

  final VoidCallback? Function(String item)? onItemTapHandlerGetter;
  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const AppPadding.only(
          top: AppUnit.xsmall,
          bottom: AppUnit.xsmall,
          start: AppUnit.small,
          end: AppUnit.xsmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppUnit.xsmall,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppUnit.tiny,
              children: [
                for (final (index, item) in items.indexed)
                  _Item(
                    onTap: onItemTapHandlerGetter?.call(item),
                    isFirst: index == 0,
                    isLast: index == items.length - 1,
                    item: item,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.onTap,
    required this.isFirst,
    required this.isLast,
    required this.item,
  });

  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;
  final String item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: 32,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppBorderRadius.horizontal(
          start: isFirst ? AppUnit.small : AppUnit.xsmall,
          end: isLast ? AppUnit.small : AppUnit.xsmall,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              item,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
