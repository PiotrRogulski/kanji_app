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
}
