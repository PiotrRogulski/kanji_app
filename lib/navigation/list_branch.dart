part of 'routes.dart';

const listBranch = TypedStatefulShellBranch<KanjiListBranch>(
  routes: [
    TypedGoRoute<KanjiListRoute>(
      path: '/list',
      routes: [TypedGoRoute<KanjiDetailsRoute>(path: ':id')],
    ),
  ],
);

class KanjiListBranch extends StatefulShellBranchData {
  const KanjiListBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiListBranch';
}

class KanjiListRoute extends GoRouteData with $KanjiListRoute {
  const KanjiListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KanjiListScreen();
  }
}

class KanjiDetailsRoute extends GoRouteData with $KanjiDetailsRoute {
  const KanjiDetailsRoute(this.id);

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return KanjiDetailsScreen(id);
  }
}
