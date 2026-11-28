part of 'routes.dart';

const listBranch = TypedStatefulShellBranch<KanjiListBranch>(
  routes: [
    TypedGoRoute<KanjiListRoute>(
      path: '/list',
      routes: [
        TypedGoRoute<KanjiDetailsRoute>(
          path: ':id',
          routes: [
            TypedGoRoute<KanjiAnimationRoute>(path: 'kanji-animation'),
            TypedGoRoute<KanjiRadicalRoute>(path: 'radical'),
          ],
        ),
      ],
    ),
  ],
);

class const KanjiListBranch() extends StatefulShellBranchData {
  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiListBranch';
}

class const KanjiListRoute() extends GoRouteData with $KanjiListRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const KanjiListScreen();
}

class const KanjiDetailsRoute(final int id)
    extends GoRouteData
    with $KanjiDetailsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      KanjiDetailsScreen(id);
}

class const KanjiAnimationRoute(final int id)
    extends GoRouteData
    with $KanjiAnimationRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (context, animation, _, child) {
          final sigma = 8 * animation.value;
          return BackdropFilter(
            filter: .blur(sigmaX: sigma, sigmaY: sigma, tileMode: .clamp),
            child: child,
          );
        },
        child: KanjiAnimationDialog(id),
      );
}

class const KanjiRadicalRoute(final int id)
    extends GoRouteData
    with $KanjiRadicalRoute {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: RadicalHero.openDuration,
        reverseTransitionDuration: RadicalHero.closeDuration,
        transitionsBuilder: (context, animation, _, child) => child,
        child: RadicalDialog(id),
      );
}
