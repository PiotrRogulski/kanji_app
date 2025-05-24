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

    // TODO: Add not found screen
    final entry = context.read<KanjiData>().get(id)!;

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
              const SliverToBoxAdapter(
                child: SizedBox(height: AppUnit.xlarge * 2),
              ),
            ],
          ),
          Positioned(
            bottom: AppUnit.large,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavButton(type: _NavButtonType.previous, id: id),
                AppUnit.tiny.gap,
                _NavButton(type: _NavButtonType.next, id: id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _NavButtonType {
  previous,
  next;

  int getTargetID(int id) => switch (this) {
    previous => id - 1,
    next => id + 1,
  };

  AppBorderRadius get borderRadius => switch (this) {
    previous => AppBorderRadius.horizontal(
      start: AppUnit.xlarge,
      end: AppUnit.xsmall,
    ),
    next => AppBorderRadius.horizontal(
      start: AppUnit.xsmall,
      end: AppUnit.xlarge,
    ),
  };

  AppIconData get icon => switch (this) {
    previous => AppIconData.chevronBackward,
    next => AppIconData.chevronForward,
  };

  String tooltip(BuildContext context) => switch (this) {
    previous => context.l10n.kanjiDetails_previous,
    next => context.l10n.kanjiDetails_next,
  };

  bool enabled(BuildContext context, int id) => switch (this) {
    previous => id > 1,
    next => id < context.read<KanjiData>().entries.last.id,
  };
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.type, required this.id});

  final _NavButtonType type;
  final int id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final enabled = type.enabled(context, id);

    return IconButton(
      icon: AppIcon(type.icon, size: 32),
      onPressed: enabled
          ? () => KanjiDetailsRoute(type.getTargetID(id)).go(context)
          : null,
      tooltip: type.tooltip(context),
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerLow,
        fixedSize: const Size.fromHeight(AppUnit.large * 2),
        padding: AppPadding.zero,
        shape: RoundedRectangleBorder(borderRadius: type.borderRadius),
      ),
    );
  }
}
