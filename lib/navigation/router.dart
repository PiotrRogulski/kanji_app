import 'package:go_router/go_router.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

GoRouter useGoRouter() {
  return useMemoized(
    () => .new(
      routes: $appRoutes,
      debugLogDiagnostics: true,
      initialLocation: const KanjiListRoute().location,
    ),
  );
}
