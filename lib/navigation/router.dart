import 'package:go_router/go_router.dart';
import 'package:kanji_app/navigation/list_branch.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

GoRouter useGoRouter() {
  return useMemoized(
    () => GoRouter(
      routes: $appRoutes,
      initialLocation: KanjiListRoute().location,
    ),
  );
}
