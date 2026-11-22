import 'package:kanji_app/design_system.dart';
import 'package:material_ui/material_ui.dart';

class const GroupedKanjiRow({
  super.key,
  final VoidCallback? Function(String item)? onItemTapHandlerGetter,
  required final String label,
  required final List<String> items,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: AppPadding(
        padding: const .only(
          top: .xsmall,
          bottom: .xsmall,
          start: .small,
          end: .xsmall,
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: AppUnit.xsmall,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Row(
              mainAxisSize: .min,
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

class const _Item({
  required final VoidCallback? onTap,
  required final bool isFirst,
  required final bool isLast,
  required final String item,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: AppUnit.xlarge,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppBorderRadius.horizontal(
          start: isFirst ? .small : .xsmall,
          end: isLast ? .small : .xsmall,
        ),
        clipBehavior: .antiAlias,
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
