import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/navigation/coordinator.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AppShell extends HookWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final coordinator = useListenable(context.coordinator);

    final s = context.l10n;
    final theme = Theme.of(context);
    final currentIndex = coordinator.currentTabIndex;

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
              currentIndex: currentIndex,
              children: [
                for (final tab in AppTab.values)
                  _TabNavigator(coordinator: coordinator, tab: tab),
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
        onSelectedIndexChange: coordinator.goToTab,
        useDrawer: false,
        internalAnimations: false,
        extendedNavigationRailWidth: 210,
        body: body,
      ),
    );
  }
}

class _TabNavigator extends HookWidget {
  const _TabNavigator({required this.coordinator, required this.tab});

  final AppCoordinator coordinator;
  final AppTab tab;

  @override
  Widget build(BuildContext context) {
    final path = coordinator.pathForTab(tab);
    final heroController = useDisposable(
      builder: MaterialApp.createMaterialHeroController,
      dispose: (heroController) => heroController.dispose(),
    );

    useListenable(path);

    return HeroControllerScope(
      controller: heroController,
      child: Navigator(
        key: coordinator.navigatorKeyForTab(tab),
        pages: [
          for (final route in path.stack)
            MaterialPage(
              key: ValueKey(route.toUri().toString()),
              child: route.build(coordinator, context),
            ),
        ],
        onDidRemovePage: (page) {
          if (path.stack.length > 1) {
            path.remove(path.stack.last);
          }
        },
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
