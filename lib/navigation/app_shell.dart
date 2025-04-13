import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

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

    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: theme.colorScheme.surfaceContainer,
        navigationRailTheme: theme.navigationRailTheme.copyWith(
          backgroundColor: theme.colorScheme.surfaceContainer,
        ),
      ),
      child: AdaptiveScaffold(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Znaki'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Zestawy'),
          NavigationDestination(
            icon: Icon(Icons.workspaces),
            label: 'Pierwiastki',
          ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onSelectedIndexChange: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        useDrawer: false,
        internalAnimations: false,
        body: body,
      ),
    );
  }
}

// TODO: Replace with a horizontal page view
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
    return Stack(
      children: [
        for (final (index, navigator) in children.indexed)
          AnimatedScale(
            scale: index == currentIndex ? 1 : 1.5,
            duration: const Duration(milliseconds: 400),
            child: AnimatedOpacity(
              opacity: index == currentIndex ? 1 : 0,
              duration: const Duration(milliseconds: 400),
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
