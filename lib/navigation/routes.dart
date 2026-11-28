import 'package:go_router/go_router.dart';
import 'package:kanji_app/features/details/kanji_details_screen.dart';
import 'package:kanji_app/features/details/widgets/kanji_animation_dialog.dart';
import 'package:kanji_app/features/details/widgets/radical_dialog.dart';
import 'package:kanji_app/features/details/widgets/radical_hero.dart';
import 'package:kanji_app/features/flashcards/flashcards_play_screen.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';
import 'package:kanji_app/features/radicals/radicals_screen.dart';
import 'package:kanji_app/navigation/app_shell.dart';
import 'package:material_ui/material_ui.dart';

part 'flashcards_branch.dart';
part 'list_branch.dart';
part 'radicals_branch.dart';
part 'routes.g.dart';

@TypedStatefulShellRoute<RootRoute>(
  branches: [listBranch, radicalsBranch, flashcardsBranch],
)
class RootRoute() extends StatefulShellRouteData {
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => navigationShell;

  static const $restorationScopeId = 'root';

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => ScaffoldWithNavBar(navigationShell: navigationShell, children: children);
}
