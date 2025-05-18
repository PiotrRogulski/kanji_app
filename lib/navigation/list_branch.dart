import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/details/kanji_details_screen.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';

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

class KanjiListRoute extends GoRouteData {
  const KanjiListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KanjiListScreen();
  }
}

class KanjiDetailsRoute extends GoRouteData {
  const KanjiDetailsRoute(this.id);

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return KanjiDetailsScreen(id);
  }
}
