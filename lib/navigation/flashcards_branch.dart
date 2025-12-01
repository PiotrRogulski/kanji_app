part of 'routes.dart';

const flashcardsBranch = TypedStatefulShellBranch<FlashcardsBranch>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<FlashcardsRoute>(
      path: '/flashcards',
      routes: [TypedGoRoute<FlashcardsPlayRoute>(path: 'play')],
    ),
  ],
);

class FlashcardsBranch extends StatefulShellBranchData {
  const FlashcardsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'flashcardsBranch';
}

class FlashcardsRoute extends GoRouteData with $FlashcardsRoute {
  const FlashcardsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FlashcardsScreen();
  }
}

class FlashcardsPlayRoute extends GoRouteData with $FlashcardsPlayRoute {
  const FlashcardsPlayRoute({
    required this.startId,
    required this.endId,
    required this.mode,
  });

  final int startId;
  final int endId;
  final FlashcardMode mode;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FlashcardsPlayScreen(startId: startId, endId: endId, mode: mode);
  }
}
