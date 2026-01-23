import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/navigation/app_shell.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

const listPathKey = PathKey('list');
const radicalsPathKey = PathKey('radicals');
const flashcardsPathKey = PathKey('flashcards');

class AppCoordinator extends Coordinator<AppRoute> {
  AppCoordinator() : super(initialRoutePath: .parse('/list')) {
    _listPath = .createWith(
      coordinator: this,
      label: 'list',
      stack: [KanjiListRoute()],
    );
    _radicalsPath = .createWith(
      coordinator: this,
      label: 'radicals',
      stack: [RadicalsRoute()],
    );
    _flashcardsPath = .createWith(
      coordinator: this,
      label: 'flashcards',
      stack: [FlashcardsRoute()],
    );
  }

  late final NavigationPath<AppRoute> _listPath;
  late final NavigationPath<AppRoute> _radicalsPath;
  late final NavigationPath<AppRoute> _flashcardsPath;

  final _listNavigatorKey = GlobalKey<NavigatorState>();
  final _radicalsNavigatorKey = GlobalKey<NavigatorState>();
  final _flashcardsNavigatorKey = GlobalKey<NavigatorState>();

  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  AppTab get currentTab => .values[_currentTabIndex];

  NavigationPath<AppRoute> pathForTab(AppTab tab) => switch (tab) {
    .list => _listPath,
    .radicals => _radicalsPath,
    .flashcards => _flashcardsPath,
  };

  GlobalKey<NavigatorState> navigatorKeyForTab(AppTab tab) => switch (tab) {
    .list => _listNavigatorKey,
    .radicals => _radicalsNavigatorKey,
    .flashcards => _flashcardsNavigatorKey,
  };

  @override
  AppRoute parseRouteFromUri(Uri uri) => switch (uri.pathSegments) {
    // List tab
    [] || ['list'] => KanjiListRoute(),
    ['list', final idStr] => _parseKanjiDetails(idStr),

    // Radicals tab
    ['radicals'] => RadicalsRoute(),

    // Flashcards tab
    ['flashcards'] => FlashcardsRoute(),
    ['flashcards', 'play'] => _parseFlashcardsPlay(uri),

    // Default: not found
    _ => NotFoundRoute(),
  };

  AppRoute _parseKanjiDetails(String idStr) => switch (int.tryParse(idStr)) {
    final id? => KanjiDetailsRoute(id),
    _ => NotFoundRoute(),
  };

  AppRoute _parseFlashcardsPlay(Uri uri) {
    final startIdStr = uri.queryParameters['start-id'];
    final endIdStr = uri.queryParameters['end-id'];
    final modeStr = uri.queryParameters['mode'];

    final startId = int.tryParse(startIdStr ?? '');
    final endId = int.tryParse(endIdStr ?? '');
    final mode = FlashcardMode.values
        .where((m) => m.name == modeStr)
        .firstOrNull;

    if (startId == null || endId == null || mode == null) {
      return FlashcardsRoute();
    }

    return FlashcardsPlayRoute(startId: startId, endId: endId, mode: mode);
  }

  Future<void> goToTab(int index) async {
    final initialLocation = currentTabIndex == index;
    _currentTabIndex = index;

    if (initialLocation) {
      final path = pathForTab(.values[index]);
      while (path.stack.length > 1) {
        final didPop = await path.pop();
        if (didPop != true) {
          break;
        }
      }
    }

    notifyListeners();
  }

  void go(AppRoute route) {
    _currentTabIndex = route.tab.index;
    pathForTab(route.tab).push(route);
    notifyListeners();
  }

  void goReplace(AppRoute route) {
    _currentTabIndex = route.tab.index;
    pathForTab(route.tab).pushReplacement(route);
    notifyListeners();
  }

  Future<void> popCurrentTab() async {
    final path = pathForTab(currentTab);
    if (path.stack.length > 1) {
      await path.pop();
      notifyListeners();
    }
  }

  bool canPopCurrentTab() => pathForTab(currentTab).stack.length > 1;

  @override
  Uri get currentUri =>
      pathForTab(currentTab).activeRoute?.toUri() ?? .parse(currentTab.path);

  @override
  Widget layoutBuilder(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: Overlay(initialEntries: [.new(builder: (_) => const AppShell())]),
    );
  }

  @override
  DefaultTransitionStrategy get transitionStrategy =>
      switch (defaultTargetPlatform) {
        .iOS || .macOS => .cupertino,
        _ => .material,
      };
}
