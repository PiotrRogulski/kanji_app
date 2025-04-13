import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/sets/kanji_sets_screen.dart';

const setsBranch = TypedStatefulShellBranch<KanjiSetsBranch>(
  routes: [TypedGoRoute<KanjiSetsRoute>(path: '/sets')],
);

class KanjiSetsBranch extends StatefulShellBranchData {
  const KanjiSetsBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiSetsBranch';
}

class KanjiSetsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KanjiSetsScreen();
  }
}
