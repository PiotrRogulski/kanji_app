import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kanji_app/design_system/icon.dart';
import 'package:kanji_app/design_system/padding.dart';
import 'package:kanji_app/extensions.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AppBigTitleScaffold extends HookWidget {
  const AppBigTitleScaffold({
    super.key,
    required this.title,
    required this.scrollController,
    this.cacheExtent,
    this.showScrollToTopFab = true,
    this.bottomChild,
    required this.slivers,
  });

  final String title;
  final ScrollController scrollController;
  final double? cacheExtent;
  final bool showScrollToTopFab;
  final Widget? bottomChild;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);

    final scrollOffset = useListenableSelector(
      scrollController,
      () => scrollController.hasClients ? scrollController.offset : 0,
    );

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: showScrollToTopFab && scrollOffset > 0
          ? FloatingActionButton(
              onPressed: () {
                if (!scrollController.hasClients) {
                  return;
                }

                if (scrollOffset > 500) {
                  scrollController.jumpTo(500);
                }

                scrollController.animateTo(
                  0,
                  duration: Durations.long1,
                  curve: Curves.easeInOutCubicEmphasized,
                );
              },
              mini: true,
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              tooltip: s.common_scrollToTop,
              child: const AppIcon(.arrowUpward, size: .large),
            )
          : null,
      body: CustomScrollView(
        controller: scrollController,
        cacheExtent: cacheExtent,
        slivers: [
          SliverPadding(
            padding: viewPadding.add(const AppEdgeInsets.all(.medium)),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: AppPadding(
                    padding: const .symmetric(horizontal: .medium),
                    child: Text(
                      title,
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                ...slivers,
                if (showScrollToTopFab) const SliverGap(48),
              ],
            ),
          ),
          if (bottomChild != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: .bottomCenter,
                padding: const AppEdgeInsets.all(.medium),
                child: ConstrainedBox(
                  constraints: const .tightFor(width: .infinity),
                  child: bottomChild,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
