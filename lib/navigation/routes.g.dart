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
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: KanjiSetBranch.$navigatorKey,
      restorationScopeId: KanjiSetBranch.$restorationScopeId,
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: RadicalsBranch.$navigatorKey,
      restorationScopeId: RadicalsBranch.$restorationScopeId,
    ),
  ],
);

extension $RootRouteExtension on RootRoute {
  static RootRoute _fromState(GoRouterState state) => RootRoute();
}
