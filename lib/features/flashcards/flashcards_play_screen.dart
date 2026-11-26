import 'dart:math';

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/liquid_glass.dart';
import 'package:kanji_app/design_system/motion.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/constants.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/flashcards/use_deck.dart';
import 'package:kanji_app/features/flashcards/use_flashcard_animation.dart';
import 'package:kanji_app/features/flashcards/use_flashcards_session.dart';
import 'package:kanji_app/features/flashcards/widgets/current_flashcard.dart';
import 'package:kanji_app/features/flashcards/widgets/flashcard_gestures.dart';
import 'package:kanji_app/features/flashcards/widgets/next_flashcards.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const FlashcardsPlayScreen({
  super.key,
  required final int startId,
  required final int endId,
  required final FlashcardMode mode,
}) extends HookWidget {
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
        onBack: () => Navigator.of(context).pop(),
      );
    }

    Future<void> requestExit() async {
      final navigator = Navigator.of(context);

      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s.flashcards_exitTitle),
            actions: [
              AppButton(
                label: s.flashcards_exitStay,
                size: .small,
                variant: .text,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              AppButton(
                label: s.flashcards_exitLeave,
                size: .small,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (shouldExit ?? false) {
        navigator.pop();
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
        body: _FlashcardsPlayBody(session: session, onExit: requestExit),
      ),
    );
  }
}

class const _FlashcardsPlayBody({
  required final FlashcardsSession session,
  required final VoidCallback onExit,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final chromeTop = viewPadding.top + AppUnit.small;

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

    return Stack(
      children: [
        Padding(
          padding: viewPadding
              .copyWith(top: chromeTop + AppGlassIconButton.size)
              .add(const AppEdgeInsets.all(.large)),
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
                      if (animationState.outgoingItem.value
                          case final outgoing?)
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
        ),
        Positioned(
          top: chromeTop,
          left: viewPadding.left + AppUnit.medium,
          right: viewPadding.right + AppUnit.medium,
          child: Row(
            spacing: AppUnit.medium,
            children: [
              AppGlassIconButton(
                icon: .arrowBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onExit,
              ),
              Expanded(
                child: AppWavyProgress(
                  value: session.learnedCount.value / session.totalCount,
                ),
              ),
              AppPadding(
                padding: const .only(end: .small),
                child: Text(
                  session.progressText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFeatures: const [.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class const _FlashcardsActionRow({
  required final bool enabled,
  required final VoidCallback onSkipped,
  required final VoidCallback onLearned,
}) extends StatelessWidget {
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

class const _FlashcardsActionButton({
  required final bool enabled,
  required final Color color,
  required final AppIconData icon,
  required final VoidCallback onPressed,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = useColorSpring(
      enabled ? color : color.withValues(alpha: color.a * 0.35),
    );

    final fill = DynamicWeight.of(context).fill;
    final stadiumProgress = useValueSpring(
      fill,
      spring: fill == 1 ? null : Springs.expressiveFastSpatial,
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

class const _FlashcardsEmptyScaffold({
  required final String title,
  required final String message,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message)),
    );
  }
}

class const _FlashcardsEndScaffold({
  required final String title,
  required final String endText,
  required final String backText,
  required final VoidCallback onBack,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const _FinishedBadge(),
            AppUnit.xlarge.gap,
            Text(endText, style: Theme.of(context).textTheme.headlineMedium),
            AppUnit.large.gap,
            AppButton(label: backText, onPressed: onBack),
          ],
        ),
      ),
    );
  }
}

class const _FinishedBadge() extends HookWidget {
  static const _size = 168.0;
  static final _shape = MaterialShapeBorder(shape: MaterialShapes.softBurst);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final controller = useUnboundedAnimationController();
    useEffect(() {
      controller.springTo(1, spring: Springs.expressiveSlowSpatial);
      return null;
    }, [controller]);
    final arrival = useAnimation(controller);

    return Transform.scale(
      scale: arrival,
      child: SizedBox.square(
        dimension: _size,
        child: Stack(
          fit: .expand,
          children: [
            Transform.rotate(
              angle: (1 - arrival) * -pi / 2,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: _shape,
                  color: colorScheme.primaryContainer,
                ),
              ),
            ),
            Center(
              child: AppIcon(
                .check,
                size: AppUnit.xlarge * 2.5,
                color: colorScheme.onPrimaryContainer,
                weight: .bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
