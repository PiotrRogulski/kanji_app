import 'package:flutter/material.dart';
import 'package:kanji_app/features/details/kanji_details_screen.dart';
import 'package:kanji_app/features/flashcards/flashcards_play_screen.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';
import 'package:kanji_app/features/radicals/radicals_screen.dart';
import 'package:kanji_app/navigation/app_coordinator.dart';
import 'package:kanji_app/navigation/layouts.dart';
import 'package:zenrouter/zenrouter.dart';

abstract class AppRoute extends RouteTarget with RouteUnique {}

// === Kanji List Branch ===

class KanjiListRoute extends AppRoute {
  @override
  Type get layout => KanjiListLayout;

  @override
  Uri toUri() => Uri.parse('/list');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const KanjiListScreen();
  }
}

class KanjiDetailsRoute extends AppRoute {
  KanjiDetailsRoute(this.id);
  final int id;

  @override
  List<Object?> get props => [id];

  @override
  Type get layout => KanjiListLayout;

  @override
  Uri toUri() => Uri.parse('/list/$id');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return KanjiDetailsScreen(id);
  }
}

// === Radicals Branch ===

class RadicalsRoute extends AppRoute {
  @override
  Type get layout => RadicalsLayout;

  @override
  Uri toUri() => Uri.parse('/radicals');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const RadicalsScreen();
  }
}

// === Flashcards Branch ===

class FlashcardsRoute extends AppRoute {
  @override
  Type get layout => FlashcardsLayout;

  @override
  Uri toUri() => Uri.parse('/flashcards');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const FlashcardsScreen();
  }
}

class FlashcardsPlayRoute extends AppRoute {
  FlashcardsPlayRoute({
    required this.startId,
    required this.endId,
    required this.mode,
  });

  final int startId;
  final int endId;
  final FlashcardMode mode;

  @override
  List<Object?> get props => [startId, endId, mode];

  @override
  Type get layout => FlashcardsLayout;

  @override
  Uri toUri() => Uri.parse('/flashcards/play')
      .replace(queryParameters: {
        'startId': startId.toString(),
        'endId': endId.toString(),
        'mode': mode.name,
      });

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return FlashcardsPlayScreen(startId: startId, endId: endId, mode: mode);
  }
}

class NotFoundRoute extends AppRoute {
  NotFoundRoute(this.uri);
  final Uri uri;

  @override
  List<Object?> get props => [uri];

  @override
  Uri toUri() => Uri.parse('/404');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text('Page not found: $uri')),
    );
  }
}
