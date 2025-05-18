import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/details/widgets/readings_group.dart';
import 'package:kanji_app/features/details/widgets/words.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KanjiDetailsScreen extends StatelessWidget {
  const KanjiDetailsScreen(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    // TODO: Add not found screen
    final kanji = context.read<KanjiData>().get(id)!;

    return switch (Breakpoints.small.isActive(context)) {
      true => _NarrowBody(kanji),
      false => _WideBody(kanji),
    };
  }
}

class _NarrowBody extends StatelessWidget {
  const _NarrowBody(this.entry);

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const AppPadding.only(end: AppUnit.small),
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const AppPadding.all(AppUnit.large),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppUnit.small,
                    children: [
                      Wrap(
                        spacing: AppUnit.small,
                        runSpacing: AppUnit.small,
                        children: [
                          KanjiTile(entry),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: AppUnit.small,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GroupedKanjiRow(
                                label: s.kanji_radical,
                                items: [entry.radical],
                              ),
                              KanjiReadingsGroup(entry),
                            ],
                          ),
                        ],
                      ),
                      if (entry.synonyms.isNotEmpty)
                        GroupedKanjiRow(
                          label: s.kanji_synonyms,
                          items: entry.synonyms,
                        ),
                      if (entry.antonyms.isNotEmpty)
                        GroupedKanjiRow(
                          label: s.kanji_antonyms,
                          items: entry.antonyms,
                        ),
                    ],
                  ),
                ),
                SliverKanjiWords(entry: entry),
              ].spacedSliver(AppUnit.small),
            ),
          ),
        ],
      ),
    );
  }
}

class _WideBody extends StatelessWidget {
  const _WideBody(this.kanji);

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    // TODO: implement wide body
    return _NarrowBody(kanji);
  }
}
