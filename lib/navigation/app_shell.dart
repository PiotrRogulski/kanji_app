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
    return AdaptiveScaffold(
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
      body:
          (context) => AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
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
