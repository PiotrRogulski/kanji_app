import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/navigation/app_shell.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<RootRoute>(
  branches: [
    TypedStatefulShellBranch<KanjiListBranch>(),
    TypedStatefulShellBranch<KanjiSetBranch>(),
    TypedStatefulShellBranch<RadicalsBranch>(),
  ],
)
class RootRoute extends StatefulShellRouteData {
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return navigationShell;
  }

  static const String $restorationScopeId = 'root';

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return ScaffoldWithNavBar(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

class KanjiListBranch extends StatefulShellBranchData {
  const KanjiListBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiListBranch';
}

class KanjiSetBranch extends StatefulShellBranchData {
  const KanjiSetBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiSetBranch';
}

class RadicalsBranch extends StatefulShellBranchData {
  const RadicalsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'radicalsBranch';
}
