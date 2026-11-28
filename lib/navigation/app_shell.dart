import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/navigation/glass_navigation_bar.dart';
import 'package:kanji_app/navigation/navigation_item.dart';
import 'package:kanji_app/navigation/navigation_rail.dart';
import 'package:kanji_app/navigation/shell_chrome.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const ScaffoldWithNavBar({
  required final StatefulNavigationShell navigationShell,
  required final List<Widget> children,
  super.key,
}) extends StatelessWidget {
  static const _mediumWidth = 600.0;
  static const _expandedWidth = 840.0;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    final currentIndex = navigationShell.currentIndex;

    void select(int index) =>
        navigationShell.goBranch(index, initialLocation: index == currentIndex);

    final destinations = <AppDestination>[
      .new(icon: .listAlt, label: s.kanjiList_title),
      .new(icon: .category, label: s.radicals_title),
      .new(icon: .style, label: s.flashcards_title),
    ];

    return ChangeNotifierProvider(
      create: (context) => ShellChrome(),
      child: switch (width) {
        < _mediumWidth => _BarShell(
          destinations: destinations,
          currentIndex: currentIndex,
          onSelected: select,
          itemDirection: .vertical,
          children: children,
        ),
        < _expandedWidth => _BarShell(
          destinations: destinations,
          currentIndex: currentIndex,
          onSelected: select,
          itemDirection: .horizontal,
          children: children,
        ),
        _ => _RailShell(
          destinations: destinations,
          currentIndex: currentIndex,
          onSelected: select,
          children: children,
        ),
      },
    );
  }
}

class const _BarShell({
  required final List<AppDestination> destinations,
  required final int currentIndex,
  required final ValueChanged<int> onSelected,
  required final Axis itemDirection,
  required final List<Widget> children,
}) extends StatelessWidget {
  static const _barMargin = AppUnit.medium;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final barBottom = max(mediaQuery.viewPadding.bottom, _barMargin);
    final contentBottom =
        barBottom + AppGlassNavigationBar.height + AppUnit.small;

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Stack(
        children: [
          Positioned.fill(
            child: MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(bottom: contentBottom),
                viewPadding: mediaQuery.viewPadding.copyWith(
                  bottom: contentBottom,
                ),
              ),
              child: AnimatedBranchContainer(
                currentIndex: currentIndex,
                direction: .horizontal,
                children: children,
              ),
            ),
          ),
          Positioned(
            left: mediaQuery.viewPadding.left + _barMargin,
            right: mediaQuery.viewPadding.right + _barMargin,
            bottom: barBottom,
            child: Center(
              child: ConstrainedBox(
                constraints: .new(
                  maxWidth: switch (itemDirection) {
                    .vertical => 480,
                    .horizontal => 560,
                  },
                ),
                child: AppGlassNavigationBar(
                  destinations: destinations,
                  selectedIndex: currentIndex,
                  onSelected: onSelected,
                  itemDirection: itemDirection,
                  onScrollToTop: context.watch<ShellChrome>().onScrollToTop,
                  scrollToTopTooltip: s.common_scrollToTop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const _RailShell({
  required final List<AppDestination> destinations,
  required final int currentIndex,
  required final ValueChanged<int> onSelected,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        minimum: const .all(AppUnit.large),
        child: Row(
          spacing: AppUnit.large,
          crossAxisAlignment: .stretch,
          children: [
            Align(
              alignment: .topCenter,
              child: Material(
                type: .transparency,
                child: AppNavigationRail(
                  destinations: destinations,
                  selectedIndex: currentIndex,
                  onSelected: onSelected,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: AppBorderRadius.circular(.xlarge),
                child: MediaQuery.removeViewPadding(
                  context: context,
                  removeBottom: true,
                  removeLeft: true,
                  removeRight: true,
                  removeTop: true,
                  child: Stack(
                    children: [
                      AnimatedBranchContainer(
                        currentIndex: currentIndex,
                        direction: .vertical,
                        children: children,
                      ),
                      PositionedDirectional(
                        bottom: AppUnit.medium,
                        end: AppUnit.medium,
                        child: _ScrollToTopButton(
                          tooltip: s.common_scrollToTop,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _ScrollToTopButton({required final String tooltip})
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final onScrollToTop = context.watch<ShellChrome>().onScrollToTop;

    final scale = useValueSpring(
      onScrollToTop != null ? 1 : 0,
      spring: Springs.expressiveFastSpatial,
    );
    if (onScrollToTop == null && scale < 0.01) {
      return const SizedBox.shrink();
    }

    return Transform.scale(
      scale: max(0, scale),
      child: AppGlassIconButton(
        icon: .arrowUpward,
        tooltip: tooltip,
        onPressed: onScrollToTop,
      ),
    );
  }
}

class const AnimatedBranchContainer({
  super.key,
  required final int currentIndex,
  required final Axis direction,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseOffset = switch (direction) {
      .horizontal => const Offset(0.1, 0),
      .vertical => const Offset(0, 0.1),
    };

    return Stack(
      children: [
        for (final (index, navigator) in children.indexed)
          _AnimatedBranch(
            position: index.compareTo(currentIndex),
            baseOffset: baseOffset,
            child: navigator,
          ),
      ],
    );
  }
}

class const _AnimatedBranch({
  required final int position,
  required final Offset baseOffset,
  required final Widget child,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final current = position == 0;

    final offset = useValueSpring(
      position.toDouble(),
      spring: Springs.expressiveDefaultSpatial,
      snapToEnd: true,
    );
    final opacity = useValueSpring(current ? 1 : 0, snapToEnd: true);

    return FractionalTranslation(
      translation: baseOffset * offset,
      child: Opacity(
        opacity: opacity,
        child: IgnorePointer(
          ignoring: !current,
          child: TickerMode(enabled: current, child: child),
        ),
      ),
    );
  }
}
