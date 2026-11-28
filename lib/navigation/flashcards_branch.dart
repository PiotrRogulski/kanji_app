part of 'routes.dart';

const flashcardsBranch = TypedStatefulShellBranch<FlashcardsBranch>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<FlashcardsRoute>(
      path: '/flashcards',
      routes: [TypedGoRoute<FlashcardsPlayRoute>(path: 'play')],
    ),
  ],
);

class const FlashcardsBranch() extends StatefulShellBranchData {
  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'flashcardsBranch';
}

class const FlashcardsRoute() extends GoRouteData with $FlashcardsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FlashcardsScreen();
}

class const FlashcardsPlayRoute({
  required final int startId,
  required final int endId,
  required final FlashcardMode mode,
}) extends GoRouteData with $FlashcardsPlayRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FlashcardsPlayScreen(startId: startId, endId: endId, mode: mode);
}
