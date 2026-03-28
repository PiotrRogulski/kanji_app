part of 'routes.dart';

const listBranch = TypedStatefulShellBranch<KanjiListBranch>(
  routes: [
    TypedGoRoute<KanjiListRoute>(
      path: '/list',
      routes: [
        TypedGoRoute<KanjiDetailsRoute>(
          path: ':id',
          routes: [TypedGoRoute<KanjiAnimationRoute>(path: 'kanji-animation')],
        ),
      ],
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

class KanjiAnimationRoute extends GoRouteData with $KanjiAnimationRoute {
  const KanjiAnimationRoute(this.id);

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
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
}
