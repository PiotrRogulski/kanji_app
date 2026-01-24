import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/navigation/layouts.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:zenrouter/zenrouter.dart';

class AppCoordinator extends Coordinator<AppRoute> {
  static final AppCoordinator instance = AppCoordinator();

  // Stacks
  late final NavigationPath<AppRoute> kanjiListStack =
      NavigationPath.createWith(label: 'kanjiList', coordinator: this);

  late final NavigationPath<AppRoute> radicalsStack =
      NavigationPath.createWith(label: 'radicals', coordinator: this);

  late final NavigationPath<AppRoute> flashcardsStack =
      NavigationPath.createWith(label: 'flashcards', coordinator: this);

  // Tabs
  late final IndexedStackPath<AppRoute> tabIndexed =
      IndexedStackPath.createWith(
    coordinator: this,
    label: 'tabs',
    [KanjiListLayout(), RadicalsLayout(), FlashcardsLayout()],
  );

  @override
  void defineLayout() {
    RouteLayout.defineLayout(RootLayout, RootLayout.new);
    RouteLayout.defineLayout(KanjiListLayout, KanjiListLayout.new);
    RouteLayout.defineLayout(RadicalsLayout, RadicalsLayout.new);
    RouteLayout.defineLayout(FlashcardsLayout, FlashcardsLayout.new);
  }

  @override
  List<StackPath> get paths => [
    ...super.paths,
    kanjiListStack,
    radicalsStack,
    flashcardsStack,
    tabIndexed,
  ];

  @override
  AppRoute parseRouteFromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return KanjiListRoute();
    }

    switch (uri.pathSegments[0]) {
      case 'list':
        if (uri.pathSegments.length == 2) {
          final id = int.tryParse(uri.pathSegments[1]);
          if (id != null) {
            return KanjiDetailsRoute(id);
          }
        }
        return KanjiListRoute();
      case 'radicals':
        return RadicalsRoute();
      case 'flashcards':
        if (uri.pathSegments.length == 2 && uri.pathSegments[1] == 'play') {
          final startId = int.tryParse(uri.queryParameters['startId'] ?? '');
          final endId = int.tryParse(uri.queryParameters['endId'] ?? '');
          final modeStr = uri.queryParameters['mode'];
          final mode = FlashcardMode.values.asNameMap()[modeStr ?? ''];

          if (startId != null && endId != null && mode != null) {
            return FlashcardsPlayRoute(
              startId: startId,
              endId: endId,
              mode: mode,
            );
          }
        }
        return FlashcardsRoute();
      default:
        return NotFoundRoute(uri);
    }
  }

  // Helpers for easier navigation (optional, but good for migration)
  void toList() => push(KanjiListRoute());
  void toDetails(int id) => push(KanjiDetailsRoute(id));
  void toRadicals() => push(RadicalsRoute());
  void toFlashcards() => push(FlashcardsRoute());
  void toFlashcardsPlay(int startId, int endId, FlashcardMode mode) {
    push(FlashcardsPlayRoute(startId: startId, endId: endId, mode: mode));
  }
}
