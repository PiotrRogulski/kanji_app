import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/design_system/dynamic_weight.dart';
import 'package:kanji_app/design_system/icon.dart';
import 'package:kanji_app/design_system/icons.dart';

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
    final theme = Theme.of(context);

    Widget body(BuildContext context) {
      final isSmall = Breakpoints.small.isActive(context);

      return Container(
        margin: switch (isSmall) {
          false => const EdgeInsetsGeometry.directional(
            top: 16,
            bottom: 16,
            end: 16,
          ),
          true => EdgeInsets.zero,
        },
        decoration: BoxDecoration(
          borderRadius: switch (isSmall) {
            false => BorderRadius.circular(16),
            true => BorderRadius.zero,
          },
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: theme,
          child: AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
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
            icon: AppIconData.listAlt,
            label: 'Znaki',
            selected: currentIndex == 0,
          ),
          AppNavigationDestination(
            icon: AppIconData.bookmark,
            label: 'Zestawy',
            selected: currentIndex == 1,
          ),
          AppNavigationDestination(
            icon: AppIconData.workspaces,
            label: 'Pierwiastki',
            selected: currentIndex == 2,
          ),
        ],
        selectedIndex: currentIndex,
        onSelectedIndexChange: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          );
        },
        useDrawer: false,
        internalAnimations: false,
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
           size: 24,
           fill: selected ? 1 : 0,
           weight: selected ? AppDynamicWeight.bold : AppDynamicWeight.regular,
         ),
       );
}
