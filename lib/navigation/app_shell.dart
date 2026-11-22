import 'dart:math';

import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:material_ui/material_ui.dart' hide NavigationDestination;

class const ScaffoldWithNavBar({
  required final StatefulNavigationShell navigationShell,
  required final List<Widget> children,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    Widget body(BuildContext context) {
      final isSmall = Breakpoints.small.isActive(context);

      final viewPadding = MediaQuery.viewPaddingOf(context);

      return Container(
        margin: switch (isSmall) {
          false => .directional(
            top: max(AppUnit.large, viewPadding.top),
            bottom: max(AppUnit.large, viewPadding.bottom),
            end: AppUnit.large,
          ),
          true => null,
        },
        decoration: BoxDecoration(
          borderRadius: switch (isSmall) {
            false => AppBorderRadius.circular(.large),
            true => .zero,
          },
        ),
        clipBehavior: .antiAlias,
        child: Theme(
          data: theme,
          child: MediaQuery.removeViewPadding(
            context: context,
            removeBottom: true,
            removeLeft: !isSmall,
            removeRight: !isSmall,
            removeTop: !isSmall,
            child: AnimatedBranchContainer(
              currentIndex: navigationShell.currentIndex,
              children: children,
            ),
          ),
        ),
      );
    }

    final currentIndex = navigationShell.currentIndex;

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
        onSelectedIndexChange: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        ),
        useDrawer: false,
        internalAnimations: false,
        extendedNavigationRailWidth: 210,
        body: body,
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
          AnimatedSlide(
            offset: baseOffset * index.compareTo(currentIndex).toDouble(),
            duration: Durations.medium4,
            curve: Curves.easeInOutCubicEmphasized,
            child: AnimatedOpacity(
              opacity: index == currentIndex ? 1 : 0,
              duration: Durations.medium4,
              curve: Curves.easeInOutCubicEmphasized,
              child: IgnorePointer(
                ignoring: index != currentIndex,
                child: TickerMode(
                  enabled: index == currentIndex,
                  child: navigator,
                ),
              ),
            ),
          ),
      ],
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
