import 'package:flutter/material.dart';
import 'package:kanji_app/design_system/icon.dart';
import 'package:kanji_app/design_system/icons.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:provider/provider.dart';

class KanjiListScreen extends StatelessWidget {
  const KanjiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final kanjiData = context.read<KanjiData>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Znaki',
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                // const SliverToBoxAdapter(child: SizedBox(height: 16)),
                PinnedHeaderSliver(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(0),
                      hintText: 'Szukaj znaków',
                      leading: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppIcon(
                          AppIconData.search,
                          size: 24,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverList.separated(
                  itemCount: kanjiData.entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder:
                      (context, index) => _Entry(kanjiData.entries[index]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry(this.entry);

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                entry.kanji,
                style: theme.textTheme.displayMedium
                    ?.apply(color: theme.colorScheme.onSurfaceVariant)
                    .copyWith(height: 1),
              ),
              if (entry.readings.onyomi.isNotEmpty)
                Text(
                  entry.readings.onyomi.join('\n'),
                  style: theme.textTheme.labelLarge?.apply(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              if (entry.readings.kunyomi.isNotEmpty)
                Text(
                  entry.readings.kunyomi.join('\n'),
                  style: theme.textTheme.labelLarge?.apply(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
