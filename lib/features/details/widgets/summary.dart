import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/features/details/widgets/kanji_tile.dart';
import 'package:kanji_app/features/details/widgets/readings_group.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

class KanjiSummary extends StatelessWidget {
  const KanjiSummary({super.key, required this.entry});

  final KanjiEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Wrap(
        spacing: AppUnit.small,
        runSpacing: AppUnit.small,
        children: [KanjiTile(entry), KanjiReadingsGroup(entry)],
      ),
    );
  }
}
