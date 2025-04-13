import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/radicals/radicals_screen.dart';

const radicalsBranch = TypedStatefulShellBranch<RadicalsBranch>(
  routes: [TypedGoRoute<RadicalsRoute>(path: '/radicals')],
);

class RadicalsBranch extends StatefulShellBranchData {
  const RadicalsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'radicalsBranch';
}

class RadicalsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RadicalsScreen();
  }
}
