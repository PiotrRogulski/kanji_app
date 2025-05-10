// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$rootRoute];

RouteBase get $rootRoute => StatefulShellRouteData.$route(
  restorationScopeId: RootRoute.$restorationScopeId,
  navigatorContainerBuilder: RootRoute.$navigatorContainerBuilder,
  factory: $RootRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: KanjiListBranch.$navigatorKey,
      restorationScopeId: KanjiListBranch.$restorationScopeId,

      routes: [
        GoRouteData.$route(
          path: '/list',

          factory: $KanjiListRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',

              factory: $KanjiDetailsRouteExtension._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: KanjiSetsBranch.$navigatorKey,
      restorationScopeId: KanjiSetsBranch.$restorationScopeId,

      routes: [
        GoRouteData.$route(
          path: '/sets',

          factory: $KanjiSetsRouteExtension._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: RadicalsBranch.$navigatorKey,
      restorationScopeId: RadicalsBranch.$restorationScopeId,

      routes: [
        GoRouteData.$route(
          path: '/radicals',

          factory: $RadicalsRouteExtension._fromState,
        ),
      ],
    ),
  ],
);

extension $RootRouteExtension on RootRoute {
  static RootRoute _fromState(GoRouterState state) => RootRoute();
}

extension $KanjiListRouteExtension on KanjiListRoute {
  static KanjiListRoute _fromState(GoRouterState state) => KanjiListRoute();

  String get location => GoRouteData.$location('/list');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $KanjiDetailsRouteExtension on KanjiDetailsRoute {
  static KanjiDetailsRoute _fromState(GoRouterState state) =>
      KanjiDetailsRoute(int.parse(state.pathParameters['id']!)!);

  String get location =>
      GoRouteData.$location('/list/${Uri.encodeComponent(id.toString())}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $KanjiSetsRouteExtension on KanjiSetsRoute {
  static KanjiSetsRoute _fromState(GoRouterState state) => KanjiSetsRoute();

  String get location => GoRouteData.$location('/sets');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RadicalsRouteExtension on RadicalsRoute {
  static RadicalsRoute _fromState(GoRouterState state) => RadicalsRoute();

  String get location => GoRouteData.$location('/radicals');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
