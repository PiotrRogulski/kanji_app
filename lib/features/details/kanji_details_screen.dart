import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/kanji_swipe_switcher.dart';
import 'package:kanji_app/features/details/widgets/sentences.dart';
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
    // TODO: Add not found screen
    final entry = context.read<KanjiData>().get(id)!;

    return KanjiSwipeSwitcher(
      entry: entry,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  actionsPadding: const AppEdgeInsets.only(end: .small),
                  floating: true,
                  snap: true,
                  actions: [
                    AppIconButton(
                      icon: .openInNew,
                      iconSize: .large,
                      onPressed: () => launchUrl(
                        Uri(
                          scheme: 'https',
                          host: 'jisho.org',
                          pathSegments: ['search', '${entry.kanji} #kanji'],
                        ),
                      ),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const AppEdgeInsets.all(.large),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      return switch (constraints.crossAxisExtent) {
                        < 700 => SliverMainAxisGroup(
                          slivers: [
                            SliverToBoxAdapter(
                              child: KanjiSummary(entry: entry),
                            ),
                            AppUnit.small.sliverGap,
                            SliverKanjiWords(entry: entry),
                            AppUnit.small.sliverGap,
                            SliverKanjiSentences(entry: entry),
                          ],
                        ),
                        _ => SliverMainAxisGroup(
                          slivers: [
                            SliverCrossAxisGroup(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: KanjiSummary(entry: entry),
                                ),
                                const SliverConstrainedCrossAxis(
                                  maxExtent: AppUnit.small,
                                  sliver: SliverToBoxAdapter(),
                                ),
                                SliverKanjiWords(entry: entry),
                              ],
                            ),
                            AppUnit.small.sliverGap,
                            SliverKanjiSentences(entry: entry),
                          ],
                        ),
                      };
                    },
                  ),
                ),
                (AppUnit.xlarge * 2 + AppUnit.large).sliverGap,
              ],
            ),
            // Positioned(
            //   bottom: AppUnit.large,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _NavButton(type: _NavButtonType.previous, id: id),
            //       AppUnit.tiny.gap,
            //       _NavButton(type: _NavButtonType.next, id: id),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// enum _NavButtonType {
//   previous,
//   next;
//
//   int getTargetID(int id) => switch (this) {
//     previous => id - 1,
//     next => id + 1,
//   };
//
//   AppBorderRadius get borderRadius => switch (this) {
//     previous => .horizontal(left: .xlarge, right: .xsmall),
//     next => .horizontal(left: .xsmall, right: .xlarge),
//   };
//
//   AppIconData get icon => switch (this) {
//     previous => .chevronBackward,
//     next => .chevronForward,
//   };
//
//   bool enabled(BuildContext context, int id) => switch (this) {
//     previous => id > 1,
//     next => id < context.read<KanjiData>().entries.last.id,
//   };
// }

// class _NavButton extends StatelessWidget {
//   const _NavButton({required this.type, required this.id});
//
//   final _NavButtonType type;
//   final int id;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     final enabled = type.enabled(context, id);
//
//     return IconButton(
//       icon: AppIcon(type.icon, size: .xlarge),
//       onPressed: enabled
//           ? () => KanjiDetailsRoute(type.getTargetID(id)).go(context)
//           : null,
//       style: IconButton.styleFrom(
//         backgroundColor: theme.colorScheme.primaryContainer,
//         disabledBackgroundColor: theme.colorScheme.surfaceContainerLow,
//         padding: .zero,
//         shape: RoundedRectangleBorder(borderRadius: type.borderRadius),
//       ),
//       constraints: BoxConstraints.tight(Size.square(AppUnit.xlarge * 2)),
//     );
//   }
// }
