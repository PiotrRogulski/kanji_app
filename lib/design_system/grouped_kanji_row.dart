import 'package:flutter/material.dart';
import 'package:kanji_app/design_system/card.dart';

class GroupedKanjiRow extends StatelessWidget {
  const GroupedKanjiRow({
    super.key,
    this.onItemTap,
    required this.label,
    required this.items,
  });

  final void Function(String item)? onItemTap;
  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 4,
          bottom: 4,
          start: 8,
          end: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                for (final (index, item) in items.indexed)
                  _Item(
                    onItemTap: onItemTap,
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
    required this.onItemTap,
    required this.isFirst,
    required this.isLast,
    required this.item,
  });

  final void Function(String item)? onItemTap;
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
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(isFirst ? 8 : 4),
          right: Radius.circular(isLast ? 8 : 4),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onItemTap != null ? () => onItemTap?.call(item) : null,
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
