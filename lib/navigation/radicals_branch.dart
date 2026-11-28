part of 'routes.dart';

const radicalsBranch = TypedStatefulShellBranch<RadicalsBranch>(
  routes: [TypedGoRoute<RadicalsRoute>(path: '/radicals')],
);

class const RadicalsBranch() extends StatefulShellBranchData {
  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'radicalsBranch';
}

class RadicalsRoute() extends GoRouteData with $RadicalsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RadicalsScreen();
}
