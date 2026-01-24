import 'package:flutter/material.dart';
import 'package:kanji_app/navigation/app_coordinator.dart';
import 'package:kanji_app/navigation/app_shell.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:zenrouter/zenrouter.dart';

class RootLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  IndexedStackPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.tabIndexed;

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return ScaffoldWithNavBar(
      path: resolvePath(coordinator),
      onTabSelected: (index) {
        switch (index) {
          case 0:
            coordinator.pushOrMoveToTop(KanjiListRoute());
          case 1:
            coordinator.pushOrMoveToTop(RadicalsRoute());
          case 2:
            coordinator.pushOrMoveToTop(FlashcardsRoute());
        }
      },
      children: [
        KanjiListLayout().buildPath(coordinator),
        RadicalsLayout().buildPath(coordinator),
        FlashcardsLayout().buildPath(coordinator),
      ],
    );
  }
}

class KanjiListLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.kanjiListStack;

  @override
  Type get layout => RootLayout;
}

class RadicalsLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.radicalsStack;

  @override
  Type get layout => RootLayout;
}

class FlashcardsLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.flashcardsStack;

  @override
  Type get layout => RootLayout;
}
