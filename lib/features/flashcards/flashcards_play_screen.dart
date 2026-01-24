import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/flashcards/use_deck.dart';
import 'package:kanji_app/features/flashcards/use_flashcard_animation.dart';
import 'package:kanji_app/features/flashcards/use_flashcards_session.dart';
import 'package:kanji_app/features/flashcards/widgets/current_flashcard.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_gestures.dart';
import 'package:kanji_app/features/flashcards/widgets/next_flashcards.dart';
import 'package:kanji_app/navigation/app_coordinator.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class FlashcardsPlayScreen extends HookWidget {
  const FlashcardsPlayScreen({
    super.key,
    required this.startId,
    required this.endId,
    required this.mode,
  });

  final int startId;
  final int endId;
  final FlashcardMode mode;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    final initialDeck = useDeck(startId: startId, endId: endId, mode: mode);
    final session = useFlashcardsSession(initialDeck);

    if (initialDeck.isEmpty) {
      return _FlashcardsEmptyScaffold(
        title: s.flashcards_title,
        message: s.flashcards_emptyDeck,
      );
    }

    if (session.isFinished) {
      return _FlashcardsEndScaffold(
        title: s.flashcards_title,
        endText: s.flashcards_end,
        backText: s.common_back,
        onBack: AppCoordinator.instance.pop,
      );
    }

    Future<void> requestExit() async {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
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
          );
        },
      );

      if (shouldExit ?? false) {
        await AppCoordinator.instance.pop();
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        requestExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(session.progressText),
          centerTitle: true,
          leading: IconButton(
            onPressed: requestExit,
            icon: const AppIcon(.arrowBack, size: .large),
          ),
        ),
        body: _FlashcardsPlayBody(session: session),
      ),
    );
  }
}

class _FlashcardsPlayBody extends HookWidget {
  const _FlashcardsPlayBody({required this.session});

  final FlashcardsSession session;

  @override
  Widget build(BuildContext context) {
    final animationState = useFlashcardAnimation();

    void dismissWithAnimation(FlashcardDismissAction action) {
      if (session.isFinished ||
          animationState.flipInProgress.value ||
          animationState.isAnimatingOut.value) {
        return;
      }

      final direction = Offset(action == .learned ? 0.2 : -0.2, -0.1);

      animationState.animationController.stop();
      animationState.animationStart.value = animationState.dragOffset.value;
      animationState.animationEnd.value =
          animationState.animationStart.value + direction * minVelocity;
      animationState.isAnimatingOut.value = true;
      animationState.outgoingItem.value = session.current;
      animationState.outgoingOffset.value = animationState.animationStart.value;

      animationState.animationController.value = 0;
      animationState.animationController.animateWith(
        SpringSimulation(spring, 0, 1, 0),
      );

      animationState.dragOffset.value = .zero;
      session.dismiss(action);
    }

    return AppPadding(
      padding: const .all(.large),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  if (session.deck.length >= 2)
                    IgnorePointer(
                      child: NextFlashcards(
                        deck: session.deck,
                        currentIndex: 0,
                        dragOffset: animationState.dragOffset.value,
                        flipInProgress: animationState.flipInProgress.value,
                      ),
                    ),
                  FlashcardGestures(
                    animationState: animationState,
                    deck: session.deck,
                    onDismissed: session.dismiss,
                    child: CurrentFlashcard(
                      item: session.current,
                      dragOffset: animationState.dragOffset.value,
                      onFlipInProgressChange: (value) =>
                          animationState.flipInProgress.value = value,
                    ),
                  ),
                  if (animationState.outgoingItem.value case final outgoing?)
                    IgnorePointer(
                      child: Opacity(
                        opacity: animationState.outgoingOpacity,
                        child: CurrentFlashcard(
                          item: outgoing,
                          dragOffset: animationState.outgoingOffset.value,
                          onFlipInProgressChange: (_) {},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AppUnit.xlarge.gap,
          _FlashcardsActionRow(
            enabled:
                !animationState.flipInProgress.value &&
                !animationState.isAnimatingOut.value,
            onSkipped: () => dismissWithAnimation(.skipped),
            onLearned: () => dismissWithAnimation(.learned),
          ),
        ],
      ),
    );
  }
}

class _FlashcardsActionRow extends StatelessWidget {
  const _FlashcardsActionRow({
    required this.enabled,
    required this.onSkipped,
    required this.onLearned,
  });

  final bool enabled;
  final VoidCallback onSkipped;
  final VoidCallback onLearned;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppUnit.small,
      children: [
        Expanded(
          child: DynamicWeight(
            child: _FlashcardsActionButton(
              enabled: enabled,
              color: Colors.orange,
              icon: .undo,
              onPressed: onSkipped,
            ),
          ),
        ),
        Expanded(
          child: DynamicWeight(
            child: _FlashcardsActionButton(
              enabled: enabled,
              color: Colors.lightGreen,
              icon: .check,
              onPressed: onLearned,
            ),
          ),
        ),
      ],
    );
  }
}

class _FlashcardsActionButton extends HookWidget {
  const _FlashcardsActionButton({
    required this.enabled,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final bool enabled;
  final Color color;
  final AppIconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = useColorSpring(
      enabled ? color : color.withValues(alpha: color.a * 0.35),
    );

    final fill = DynamicWeight.of(context).fill;
    final stadiumProgress = useValueSpring(
      fill,
      ratio: fill == 1 ? 1 : 0.5,
      stiffness: 1000,
    );

    return Material(
      color: effectiveColor,
      shape: StadiumMorphBorder(
        fixedCornerRadius: .medium,
        stadiumProgress: stadiumProgress,
      ),
      animationDuration: .zero,
      clipBehavior: .antiAlias,
      child: AppInkWell(
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        child: AppPadding(
          padding: const .all(.small),
          child: AppIcon(
            icon,
            size: AppUnit.xlarge * 2,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _FlashcardsEmptyScaffold extends StatelessWidget {
  const _FlashcardsEmptyScaffold({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message)),
    );
  }
}

class _FlashcardsEndScaffold extends StatelessWidget {
  const _FlashcardsEndScaffold({
    required this.title,
    required this.endText,
    required this.backText,
    required this.onBack,
  });

  final String title;
  final String endText;
  final String backText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(endText, style: Theme.of(context).textTheme.headlineMedium),
            AppUnit.large.gap,
            FilledButton(onPressed: onBack, child: Text(backText)),
          ],
        ),
      ),
    );
  }
}
