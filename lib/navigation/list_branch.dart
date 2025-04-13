import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';

const listBranch = TypedStatefulShellBranch<KanjiListBranch>(
  routes: [TypedGoRoute<KanjiListRoute>(path: '/list')],
);

class KanjiListBranch extends StatefulShellBranchData {
  const KanjiListBranch();

  static final $navigatorKey = GlobalKey<NavigatorState>();
  static const $restorationScopeId = 'kanjiListBranch';
}

class KanjiListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KanjiListScreen();
  }
}
