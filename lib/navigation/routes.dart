import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/details/kanji_details_screen.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';
import 'package:kanji_app/features/radicals/radicals_screen.dart';
import 'package:kanji_app/navigation/app_shell.dart';

part 'routes.g.dart';
part 'list_branch.dart';
part 'radicals_branch.dart';
// part 'sets_branch.dart';

@TypedStatefulShellRoute<RootRoute>(
  branches: [
    listBranch,
    // TODO: define & bring back sets
    // setsBranch,
    radicalsBranch,
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

  static const $restorationScopeId = 'root';

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
