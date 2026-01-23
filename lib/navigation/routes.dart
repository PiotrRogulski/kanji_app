import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanji_app/features/details/kanji_details_screen.dart';
import 'package:kanji_app/features/flashcards/flashcards_play_screen.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/list/kanji_list_screen.dart';
import 'package:kanji_app/features/radicals/radicals_screen.dart';
import 'package:kanji_app/l10n/app_l10n.dart';
import 'package:kanji_app/navigation/coordinator.dart';
import 'package:zenrouter/zenrouter.dart';

sealed class AppRoute extends RouteTarget with RouteUnique {
  @override
  Widget build(AppCoordinator coordinator, BuildContext context);

  AppTab get tab;
}

enum AppTab {
  list,
  radicals,
  flashcards;

  String get path => switch (this) {
    list => '/list',
    radicals => '/radicals',
    flashcards => '/flashcards',
  };

  AppRoute get rootRoute => switch (this) {
    list => KanjiListRoute(),
    radicals => RadicalsRoute(),
    flashcards => FlashcardsRoute(),
  };
}

// =============================================================================
// List Tab Routes
// =============================================================================

class KanjiListRoute extends AppRoute {
  @override
  AppTab get tab => .list;

  @override
  Uri toUri() => .parse('/list');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const KanjiListScreen();
  }
}

class KanjiDetailsRoute extends AppRoute {
  KanjiDetailsRoute(this.id);

  final int id;

  @override
  AppTab get tab => .list;

  @override
  List<Object?> get props => [id];

  @override
  Uri toUri() => .parse('/list/$id');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return KanjiDetailsScreen(id);
  }
}

// =============================================================================
// Radicals Tab Routes
// =============================================================================

class RadicalsRoute extends AppRoute {
  @override
  AppTab get tab => .radicals;

  @override
  Uri toUri() => .parse('/radicals');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const RadicalsScreen();
  }
}

// =============================================================================
// Flashcards Tab Routes
// =============================================================================

class FlashcardsRoute extends AppRoute {
  @override
  AppTab get tab => .flashcards;

  @override
  Uri toUri() => .parse('/flashcards');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const FlashcardsScreen();
  }
}

class FlashcardsPlayRoute extends AppRoute with RouteGuard {
  FlashcardsPlayRoute({
    required this.startId,
    required this.endId,
    required this.mode,
  });

  final int startId;
  final int endId;
  final FlashcardMode mode;

  /// Whether the session is active and needs exit confirmation.
  /// Set to false when the session is finished or deck is empty.
  bool needsExitConfirmation = true;

  @override
  AppTab get tab => .flashcards;

  @override
  List<Object?> get props => [startId, endId, mode];

  @override
  Uri toUri() => .new(
    path: '/flashcards/play',
    queryParameters: {
      'start-id': startId.toString(),
      'end-id': endId.toString(),
      'mode': mode.name,
    },
  );

  @override
  FutureOr<bool> popGuardWith(AppCoordinator coordinator) async {
    if (!needsExitConfirmation) {
      return true;
    }

    final context = coordinator.navigatorKeyForTab(tab).currentContext;
    if (context == null || !context.mounted) {
      return true;
    }

    final s = AppLocalizations.of(context);

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.flashcards_exitTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(s.flashcards_exitStay),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(s.flashcards_exitLeave),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return FlashcardsPlayScreen(
      startId: startId,
      endId: endId,
      mode: mode,
      onSessionActiveChanged: (active) => needsExitConfirmation = active,
    );
  }
}

// =============================================================================
// Not Found Route
// =============================================================================

class NotFoundRoute extends AppRoute {
  @override
  AppTab get tab => .list;

  @override
  Uri toUri() => .parse('/404');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found')));
  }
}
