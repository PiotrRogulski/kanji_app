import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/navigation/app_shell.dart';
import 'package:kanji_app/navigation/list_branch.dart';
import 'package:kanji_app/navigation/radicals_branch.dart';
import 'package:kanji_app/navigation/sets_branch.dart';

part 'routes.g.dart';

@TypedStatefulShellRoute<RootRoute>(
  branches: [listBranch, setsBranch, radicalsBranch],
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
