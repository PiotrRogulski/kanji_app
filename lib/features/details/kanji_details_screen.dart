import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/summary.dart';
import 'package:kanji_app/features/details/widgets/words.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KanjiDetailsScreen extends StatelessWidget {
  const KanjiDetailsScreen(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    // TODO: Add not found screen
    final entry = context.read<KanjiData>().get(id)!;

    return Scaffold(
      body: CustomScrollView(
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
        ],
      ),
    );
  }
}
