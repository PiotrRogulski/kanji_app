part of 'routes.dart';

const setsBranch = TypedStatefulShellBranch<KanjiSetsBranch>(
  routes: [TypedGoRoute<KanjiSetsRoute>(path: '/sets')],
);

class KanjiSetsBranch extends StatefulShellBranchData {
  const KanjiSetsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiSetsBranch';
}

class KanjiSetsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KanjiSetsScreen();
  }
}
