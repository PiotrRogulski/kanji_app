import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    Widget body(BuildContext context) {
      final isSmall = Breakpoints.small.isActive(context);

      final viewPadding = MediaQuery.viewPaddingOf(context);

      return Container(
        margin: switch (isSmall) {
          false => EdgeInsetsDirectional.only(
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
          // TODO: define & bring back sets
          // AppNavigationDestination(
          //   icon: .bookmark,
          //   label: s.kanjiSets_title,
          //   selected: currentIndex == ???,
          // ),
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

class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

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

class AppNavigationDestination extends NavigationDestination {
  AppNavigationDestination({
    super.key,
    required super.label,
    required AppIconData icon,
    required bool selected,
  }) : super(
         icon: AppIcon(
           icon,
           size: .large,
           fill: selected ? 1 : 0,
           weight: selected ? .bold : .light,
         ),
       );
}
