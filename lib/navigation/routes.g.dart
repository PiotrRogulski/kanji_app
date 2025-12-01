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
      navigatorKey: RadicalsBranch.$navigatorKey,
      restorationScopeId: RadicalsBranch.$restorationScopeId,
      routes: [
        GoRouteData.$route(
          path: '/radicals',
          factory: $RadicalsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: FlashcardsBranch.$navigatorKey,
      restorationScopeId: FlashcardsBranch.$restorationScopeId,
      routes: [
        GoRouteData.$route(
          path: '/flashcards',
          factory: $FlashcardsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'play',
              factory: $FlashcardsPlayRoute._fromState,
            ),
          ],
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

mixin $FlashcardsRoute on GoRouteData {
  static FlashcardsRoute _fromState(GoRouterState state) =>
      const FlashcardsRoute();

  @override
  String get location => GoRouteData.$location('/flashcards');

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

mixin $FlashcardsPlayRoute on GoRouteData {
  static FlashcardsPlayRoute _fromState(GoRouterState state) =>
      FlashcardsPlayRoute(
        startId: int.parse(state.uri.queryParameters['start-id']!),
        endId: int.parse(state.uri.queryParameters['end-id']!),
        mode: _$FlashcardModeEnumMap._$fromName(
          state.uri.queryParameters['mode']!,
        )!,
      );

  FlashcardsPlayRoute get _self => this as FlashcardsPlayRoute;

  @override
  String get location => GoRouteData.$location(
    '/flashcards/play',
    queryParams: {
      'start-id': _self.startId.toString(),
      'end-id': _self.endId.toString(),
      'mode': _$FlashcardModeEnumMap[_self.mode],
    },
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

const _$FlashcardModeEnumMap = {
  FlashcardMode.kanji: 'kanji',
  FlashcardMode.words: 'words',
  FlashcardMode.mixed: 'mixed',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}
