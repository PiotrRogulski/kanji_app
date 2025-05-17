import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/details/widgets/readings_group.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:provider/provider.dart';

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
  const _NarrowBody(this.kanji);

  final KanjiEntry kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                          KanjiTile(kanji),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: AppUnit.small,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GroupedKanjiRow(
                                label: 'Pierwiastek',
                                items: [kanji.radical],
                              ),
                              KanjiReadingsGroup(kanji),
                            ],
                          ),
                        ],
                      ),
                      if (kanji.synonyms.isNotEmpty)
                        GroupedKanjiRow(
                          label: 'Synonimy',
                          items: kanji.synonyms,
                        ),
                      if (kanji.antonyms.isNotEmpty)
                        GroupedKanjiRow(
                          label: 'Antonimy',
                          items: kanji.antonyms,
                        ),
                    ],
                  ),
                ),
              ],
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
