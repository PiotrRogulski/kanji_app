import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/flashcards/flashcards_screen.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

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
    final kanjiData = context.watch<KanjiData>();

    final deck = useMemoized(() {
      final entries = kanjiData.entries.where(
        (e) => e.id >= startId && e.id <= endId,
      );

      return <FlashcardItem>[
        for (final entry in entries) ...[
          if (mode case .kanji || .mixed)
            .new(
              frontText: entry.kanji,
              backText: entry.readings.join('\n'),
              type: .kanji,
            ),
          if (mode case .words || .mixed)
            for (final word in entry.wordsRequiredNow)
              .new(
                frontText: word.kanji.isNotEmpty ? word.kanji : word.reading,
                backText: word.meaning,
                subTextBack: word.reading,
                type: .word,
              ),
        ],
      ]..shuffle();
    }, [startId, endId, mode, kanjiData]);

    final currentIndex = useState(0);
    final dragOffset = useState(Offset.zero);
    final flipInProgress = useState(false);

    final animationController = useAnimationController(
      duration: Durations.medium3,
    );
    final animationStart = useState(Offset.zero);
    final animationEnd = useState(Offset.zero);
    final isAnimatingOut = useState(false);

    useEffect(() {
      void listener() {
        final t = Curves.easeOutBack.transform(animationController.value);
        dragOffset.value = .lerp(animationStart.value, animationEnd.value, t)!;
      }

      void statusListener(AnimationStatus status) {
        if (status == .completed && isAnimatingOut.value) {
          currentIndex.value++;
          dragOffset.value = .zero;
          isAnimatingOut.value = false;
        }
      }

      animationController
        ..addListener(listener)
        ..addStatusListener(statusListener);

      return () {
        animationController
          ..removeListener(listener)
          ..removeStatusListener(statusListener);
      };
    }, [animationController, animationStart.value, animationEnd.value]);

    if (deck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(s.flashcards_title)),
        body: Center(child: Text(s.flashcards_emptyDeck)),
      );
    }

    if (currentIndex.value >= deck.length) {
      return Scaffold(
        appBar: AppBar(title: Text(s.flashcards_title)),
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                s.flashcards_end,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              AppUnit.large.gap,
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(s.common_back),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentIndex.value + 1} / ${deck.length}'),
        centerTitle: true,
      ),
      body: AppPadding(
        padding: const .all(.large),
        child: Center(
          child: Stack(
            children: [
              if (currentIndex.value + 1 < deck.length)
                IgnorePointer(
                  child: Builder(
                    builder: (context) {
                      final distance = dragOffset.value.distance.clamp(0, 200);
                      final eased = Curves.easeOut.transform(distance / 200);

                      final level2Dy = 10 * (1 - eased);
                      final level2Scale = 0.95 + 0.05 * eased;

                      final hasThird = currentIndex.value + 2 < deck.length;

                      return Stack(
                        children: [
                          if (hasThird)
                            Opacity(
                              opacity: eased,
                              child: Transform.translate(
                                offset: const .new(0, 10),
                                child: Transform.scale(
                                  scale: 0.95,
                                  alignment: .bottomCenter,
                                  child: FlashcardView(
                                    key: ValueKey(deck[currentIndex.value + 2]),
                                    item: deck[currentIndex.value + 2],
                                    hideContent: flipInProgress.value,
                                  ),
                                ),
                              ),
                            ),
                          Transform.translate(
                            offset: .new(0, level2Dy),
                            child: Transform.scale(
                              scale: level2Scale,
                              alignment: .bottomCenter,
                              child: FlashcardView(
                                key: ValueKey(deck[currentIndex.value + 1]),
                                item: deck[currentIndex.value + 1],
                                hideContent: flipInProgress.value,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              GestureDetector(
                onPanStart: (_) {
                  if (flipInProgress.value) {
                    return;
                  }
                  animationController.stop();
                  isAnimatingOut.value = false;
                },
                onPanUpdate: (details) {
                  if (flipInProgress.value) {
                    return;
                  }
                  dragOffset.value += details.delta;
                },
                onPanEnd: (details) {
                  final velocity = details.velocity.pixelsPerSecond;
                  final distance = dragOffset.value.distance;
                  final velocityMagnitude = velocity.distance;

                  const dismissDistance = 180.0;
                  const minVelocity = 800.0;

                  final shouldDismiss =
                      distance > dismissDistance ||
                      velocityMagnitude > minVelocity;

                  if (shouldDismiss) {
                    final direction = () {
                      if (distance > 0) {
                        return dragOffset.value / distance;
                      }
                      if (velocityMagnitude > 0) {
                        return velocity / velocityMagnitude;
                      }
                      return const Offset(1, 0);
                    }();

                    animationStart.value = dragOffset.value;
                    animationEnd.value = dragOffset.value + direction * 800.0;
                    isAnimatingOut.value = true;
                    animationController
                      ..value = 0
                      ..forward();
                  } else {
                    animationStart.value = dragOffset.value;
                    animationEnd.value = .zero;
                    isAnimatingOut.value = false;
                    animationController
                      ..value = 0
                      ..forward();
                  }
                },
                child: Builder(
                  builder: (context) {
                    final distance = dragOffset.value.distance.clamp(
                      0.0,
                      200.0,
                    );
                    final t = Curves.easeOut.transform(distance / 200);
                    final angle = 0.06 * (dragOffset.value.dx / 200);
                    final scale = 1.0 - 0.05 * t;
                    final opacity = 1.0 - 0.25 * t;

                    return Transform.translate(
                      offset: dragOffset.value,
                      child: Transform.rotate(
                        angle: angle,
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: FlashcardView(
                              key: ValueKey(deck[currentIndex.value]),
                              item: deck[currentIndex.value],
                              onFlipInProgressChange: (value) =>
                                  flipInProgress.value = value,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum FlashcardType { kanji, word }

class FlashcardItem {
  FlashcardItem({
    required this.frontText,
    required this.backText,
    this.subTextBack,
    required this.type,
  });

  final String frontText;
  final String backText;
  final String? subTextBack;
  final FlashcardType type;
}

class FlashcardView extends HookWidget {
  const FlashcardView({
    super.key,
    required this.item,
    this.onFlipInProgressChange,
    this.hideContent = false,
  });

  final FlashcardItem item;
  final ValueChanged<bool>? onFlipInProgressChange;
  final bool hideContent;

  @override
  Widget build(BuildContext context) {
    final controller = useUnboundedAnimationController();
    final isFlipped = useState(false);

    useEffect(() {
      if (onFlipInProgressChange == null) {
        return null;
      }

      void listener(AnimationStatus status) {
        onFlipInProgressChange!.call(status == .forward || status == .reverse);
      }

      controller.addStatusListener(listener);

      return () => controller.removeStatusListener(listener);
    }, [controller, onFlipInProgressChange]);

    return GestureDetector(
      onTap: () {
        final spring = SpringDescription.withDampingRatio(
          mass: 1,
          stiffness: 300,
          ratio: 0.8,
        );
        if (isFlipped.value) {
          controller.animateWith(
            SpringSimulation(spring, controller.value, 0, 0, snapToEnd: true),
          );
        } else {
          controller.animateWith(
            SpringSimulation(spring, controller.value, 1, 0, snapToEnd: true),
          );
        }
        isFlipped.value = !isFlipped.value;
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * pi;
          final isBackVisible = controller.value >= 0.5;

          var transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          if (isBackVisible) {
            transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle + pi);
          }

          return Transform(
            transform: transform,
            alignment: .center,
            child: isBackVisible
                ? _buildSide(context, isFront: false)
                : _buildSide(context, isFront: true),
          );
        },
      ),
    );
  }

  Widget _buildSide(BuildContext context, {required bool isFront}) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth.clamp(280.0, 600.0);
        final cardHeight = constraints.maxHeight.clamp(260.0, 1600.0);

        return Center(
          child: Card(
            key: ValueKey(isFront),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.circular(.large),
            ),
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: AppPadding(
                padding: const .all(.xlarge),
                child: Opacity(
                  opacity: hideContent ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    mainAxisAlignment: .center,
                    children: [
                      if (isFront)
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                item.frontText,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: item.type == .kanji ? 140 : 56,
                                ),
                                textAlign: .center,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        Center(
                          child: Text(
                            item.backText,
                            style: theme.textTheme.headlineLarge,
                            textAlign: .center,
                          ),
                        ),
                        AppUnit.medium.gap,
                        if (item.subTextBack case final subTextBack?)
                          Text(
                            subTextBack,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: .center,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
