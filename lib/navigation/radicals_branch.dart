part of 'routes.dart';

const radicalsBranch = TypedStatefulShellBranch<RadicalsBranch>(
  routes: [TypedGoRoute<RadicalsRoute>(path: '/radicals')],
);

class RadicalsBranch extends StatefulShellBranchData {
  const RadicalsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'radicalsBranch';
}

class RadicalsRoute extends GoRouteData with _$RadicalsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RadicalsScreen();
  }
}
