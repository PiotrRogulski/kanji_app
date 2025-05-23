import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/summary.dart';
import 'package:kanji_app/features/details/widgets/words.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KanjiDetailsScreen extends StatelessWidget {
  const KanjiDetailsScreen(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final kanjiData = context.read<KanjiData>();
    final allKanjiEntries = kanjiData.entries;

    // TODO: Add not found screen
    final entry = kanjiData.get(id)!;

    // KanjiData.entries is guaranteed not to be empty.
    final int lastKanjiId = allKanjiEntries.last.id;

    final bool canGoToPrevious = id > 1;
    final bool canGoToNext = id < lastKanjiId;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                actionsPadding: const AppPadding.only(end: AppUnit.small),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    icon: const AppIcon(AppIconData.openInNew, size: 24),
                    onPressed: () => launchUrl(
                      Uri(
                        scheme: 'https',
                        host: 'jisho.org',
                        pathSegments: ['search', '${entry.kanji} #kanji'],
                      ),
                    ),
                    tooltip: s.kanji_openInJisho,
                  ),
                ],
              ),
              SliverPadding(
                padding: const AppPadding.all(AppUnit.large),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    return switch (constraints.crossAxisExtent) {
                      < 700 => SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(child: KanjiSummary(entry: entry)),
                          AppUnit.small.sliverGap,
                          SliverKanjiWords(entry: entry),
                        ],
                      ),
                      _ => SliverCrossAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(child: KanjiSummary(entry: entry)),
                          const SliverConstrainedCrossAxis(
                            maxExtent: AppUnit.small,
                            sliver: SliverToBoxAdapter(),
                          ),
                          SliverKanjiWords(entry: entry),
                        ],
                      ),
                    };
                  },
                ),
              ),
              // Add padding at the bottom of the scroll view so content isn't obscured by buttons
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppUnit.large.value * 5,
                ), // 5 * 16.0 = 80.0
              ),
            ],
          ),
          Positioned(
            bottom: AppUnit.large.value, // 16.0
            // left: 0 and right: 0 are removed as per instruction
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const AppIcon(AppIconData.arrowLeft, size: 32),
                    onPressed: canGoToPrevious
                        ? () => KanjiDetailsRoute(id - 1).go(context)
                        : null,
                    tooltip: s.previousKanjiTooltip,
                  ),
                  SizedBox(
                    width: AppUnit.large.value + AppUnit.xsmall.value,
                  ), // 16.0 + 4.0 = 20.0
                  IconButton(
                    icon: const AppIcon(AppIconData.arrowRight, size: 32),
                    onPressed: canGoToNext
                        ? () => KanjiDetailsRoute(id + 1).go(context)
                        : null,
                    tooltip: s.nextKanjiTooltip,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
