import 'dart:math';

import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/navigation/glass_navigation_bar.dart';
import 'package:kanji_app/navigation/shell_chrome.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart' hide NavigationDestination;
import 'package:provider/provider.dart';

class const ScaffoldWithNavBar({
  required final StatefulNavigationShell navigationShell,
  required final List<Widget> children,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    void select(int index) =>
        navigationShell.goBranch(index, initialLocation: index == currentIndex);

    return ChangeNotifierProvider(
      create: (context) => ShellChrome(),
      child: switch (Breakpoints.small.isActive(context)) {
        true => _CompactShell(
          currentIndex: currentIndex,
          onSelected: select,
          children: children,
        ),
        false => _ExpandedShell(
          currentIndex: currentIndex,
          onSelected: select,
          children: children,
        ),
      },
    );
  }
}

class const _CompactShell({
  required final int currentIndex,
  required final ValueChanged<int> onSelected,
  required final List<Widget> children,
}) extends StatelessWidget {
  static const _barMaxWidth = 480.0;
  static const _barMargin = AppUnit.medium;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final barBottom = max<double>(mediaQuery.viewPadding.bottom, _barMargin);
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
                constraints: const .new(maxWidth: _barMaxWidth),
                child: AppGlassNavigationBar(
                  destinations: [
                    .new(icon: .listAlt, label: s.kanjiList_title),
                    .new(icon: .category, label: s.radicals_title),
                    .new(icon: .style, label: s.flashcards_title),
                  ],
                  selectedIndex: currentIndex,
                  onSelected: onSelected,
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

class const _ExpandedShell({
  required final int currentIndex,
  required final ValueChanged<int> onSelected,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    Widget body(BuildContext context) {
      final viewPadding = MediaQuery.viewPaddingOf(context);

      return Container(
        margin: .directional(
          top: max(AppUnit.large, viewPadding.top),
          bottom: max(AppUnit.large, viewPadding.bottom),
          end: AppUnit.large,
        ),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.circular(.xlarge),
        ),
        clipBehavior: .antiAlias,
        child: Theme(
          data: theme,
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
                  children: children,
                ),
                PositionedDirectional(
                  bottom: AppUnit.medium,
                  end: AppUnit.medium,
                  child: _ScrollToTopButton(tooltip: s.common_scrollToTop),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: theme.colorScheme.surfaceContainer,
        navigationRailTheme: theme.navigationRailTheme.copyWith(
          backgroundColor: theme.colorScheme.surfaceContainer,
        ),
      ),
      child: AdaptiveScaffold(
        destinations: [
          AppNavigationDestination(
            icon: .listAlt,
            label: s.kanjiList_title,
            selected: currentIndex == 0,
          ),
          AppNavigationDestination(
            icon: .category,
            label: s.radicals_title,
            selected: currentIndex == 1,
          ),
          AppNavigationDestination(
            icon: .style,
            label: s.flashcards_title,
            selected: currentIndex == 2,
          ),
        ],
        selectedIndex: currentIndex,
        onSelectedIndexChange: onSelected,
        useDrawer: false,
        internalAnimations: false,
        extendedNavigationRailWidth: 210,
        body: body,
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
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseOffset = switch (Breakpoints.small.isActive(context)) {
      true => const Offset(0.1, 0),
      false => const Offset(0, 0.1),
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

// https://github.com/dart-lang/sdk/issues/64037
// ignore: prefer_const_constructors_in_immutables
class AppNavigationDestination({
  super.key,
  required super.label,
  required AppIconData icon,
  required bool selected,
}) extends NavigationDestination {
  this
    : super(
        icon: AppIcon(
          icon,
          size: .large,
          fill: selected ? 1 : 0,
          weight: selected ? .bold : .light,
        ),
      );
}
