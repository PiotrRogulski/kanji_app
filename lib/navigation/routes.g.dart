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
          factory: $KanjiListRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              factory: $KanjiDetailsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: KanjiSetsBranch.$navigatorKey,
      restorationScopeId: KanjiSetsBranch.$restorationScopeId,
      routes: [
        GoRouteData.$route(path: '/sets', factory: $KanjiSetsRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: RadicalsBranch.$navigatorKey,
      restorationScopeId: RadicalsBranch.$restorationScopeId,
      routes: [
        GoRouteData.$route(
          path: '/radicals',
          factory: $RadicalsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $RootRouteExtension on RootRoute {
  static RootRoute _fromState(GoRouterState state) => RootRoute();
}

mixin $KanjiListRoute on GoRouteData {
  static KanjiListRoute _fromState(GoRouterState state) =>
      const KanjiListRoute();

  @override
  String get location => GoRouteData.$location('/list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $KanjiDetailsRoute on GoRouteData {
  static KanjiDetailsRoute _fromState(GoRouterState state) =>
      KanjiDetailsRoute(int.parse(state.pathParameters['id']!));

  KanjiDetailsRoute get _self => this as KanjiDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/list/${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $KanjiSetsRoute on GoRouteData {
  static KanjiSetsRoute _fromState(GoRouterState state) => KanjiSetsRoute();

  @override
  String get location => GoRouteData.$location('/sets');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RadicalsRoute on GoRouteData {
  static RadicalsRoute _fromState(GoRouterState state) => RadicalsRoute();

  @override
  String get location => GoRouteData.$location('/radicals');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
