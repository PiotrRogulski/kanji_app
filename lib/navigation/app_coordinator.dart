import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/navigation/layouts.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:zenrouter/zenrouter.dart';

class AppCoordinator extends Coordinator<AppRoute> {
  late final kanjiListStack = NavigationPath<AppRoute>.createWith(
    label: 'kanjiList',
    coordinator: this,
  );

  late final radicalsStack = NavigationPath<AppRoute>.createWith(
    label: 'radicals',
    coordinator: this,
  );

  late final flashcardsStack = NavigationPath<AppRoute>.createWith(
    label: 'flashcards',
    coordinator: this,
  );

  // Tabs
  late final tabIndexed = IndexedStackPath<AppRoute>.createWith(
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
  AppRoute parseRouteFromUri(Uri uri) => switch (uri.pathSegments) {
    [] || ['list'] => KanjiListRoute(),
    ['list', final id] when int.tryParse(id) != null => KanjiDetailsRoute(
      .parse(id),
    ),
    ['radicals'] => RadicalsRoute(),
    ['flashcards'] => FlashcardsRoute(),
    ['flashcards', 'play'] => _parseFlashcardsPlay(uri),
    _ => NotFoundRoute(uri),
  };

  AppRoute _parseFlashcardsPlay(Uri uri) {
    final startId = int.tryParse(uri.queryParameters['startId'] ?? '');
    final endId = int.tryParse(uri.queryParameters['endId'] ?? '');
    final mode = FlashcardMode.values.asNameMap()[uri.queryParameters['mode']];

    if (startId != null && endId != null && mode != null) {
      return FlashcardsPlayRoute(startId: startId, endId: endId, mode: mode);
    } else {
      return FlashcardsRoute();
    }
  }
}
