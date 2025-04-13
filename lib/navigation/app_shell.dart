import 'package:flutter/material.dart';
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
    return Scaffold(
      body: AnimatedBranchContainer(
        currentIndex: navigationShell.currentIndex,
        children: children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Znaki'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Zestawy'),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces),
            label: 'Pierwiastki',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
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
