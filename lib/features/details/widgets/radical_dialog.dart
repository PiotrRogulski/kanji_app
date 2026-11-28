import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:kanji_app/common/use_unbounded_animation_controller.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/motion.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/radical.dart';
import 'package:kanji_app/features/details/widgets/radical_glyph.dart';
import 'package:kanji_app/features/details/widgets/radical_hero.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:kanji_app/features/radicals/radical_entry_view.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const RadicalDialog(final int kanjiId, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radical = context
        .watch<KanjiData>()
        .get(kanjiId)
        ?.apply(context.watch<RadicalsData>().of);
    // TODO: Add not found screen
    if (radical == null) {
      return const SizedBox.shrink();
    }

    return _RadicalDialog(kanjiId, radical);
  }
}

class const _RadicalDialog(final int kanjiId, final KanjiRadicalData data)
    extends HookWidget {
  static const _blurSigma = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final KanjiRadicalData(entry: radical, :form) = data;
    final otherForms = radical.radicals.where((f) => f != form);

    final route = ModalRoute.of(context)!.animation!;
    final open = useListenableSelector(
      route,
      () => route.status.isForwardOrCompleted,
    );

    final blur = _useSpring(
      open ? 1 : 0,
      from: 0,
      spring: Springs.expressiveSlowEffects,
    );

    final details = [
      Text(
        radical.names,
        textAlign: .center,
        style: theme.textTheme.titleLarge,
      ),
      Text(
        radical.meaning,
        textAlign: .center,
        style: theme.textTheme.titleMedium?.apply(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      if (otherForms.isNotEmpty || radical.relatedRadicals.isNotEmpty)
        AppPadding(
          padding: const .only(top: .small),
          child: RadicalRelatedForms(
            radical,
            otherForms: otherForms,
            alignment: .center,
          ),
        ),
      AppPadding(
        padding: const .only(top: .small),
        child: RadicalExamples(radical),
      ),
    ];

    final sigma = _blurSigma * blur;

    return BackdropFilter(
      filter: .blur(sigmaX: sigma, sigmaY: sigma, tileMode: .clamp),
      child: Center(
        child: SingleChildScrollView(
          clipBehavior: .none,
          padding: const AppEdgeInsets.all(.large),
          child: ConstrainedBox(
            constraints: const .new(maxWidth: 360),
            child: Material(
              type: .transparency,
              child: _Container(
                open: open,
                kanjiId: kanjiId,
                child: AppPadding(
                  padding: const .all(.large),
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    children: [
                      Center(
                        child: SizedBox.square(
                          dimension: AppUnit.xlarge * 5,
                          child: RadicalHero(
                            kanjiId: kanjiId,
                            form: form,
                            child: RadicalGlyph.badge(form, theme),
                          ),
                        ),
                      ),
                      AppUnit.medium.gap,
                      for (final (index, detail) in details.indexed)
                        _Staggered(
                          open: open,
                          index: index,
                          child: Center(child: detail),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _Container({
  required final bool open,
  required final int kanjiId,
  required final Widget child,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final progress = _useSpring(
      open ? 1 : 0,
      from: 0,
      spring: open ? RadicalHero.openSpring : RadicalHero.closeSpring,
      keepVelocity: true,
    );
    final contentSwap = _useSpring(
      open ? 1 : 0,
      from: 0,
      spring: Springs.expressiveDefaultEffects,
    );

    // Where the row is, seen from here, and how big the card gets. They're
    // read after the frame, as during a build the tree can be halfway through
    // a change and not laid out.
    final geometry = useState<({Rect from, Size size})?>(null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      final origin = KanjiRadical.rectOf(kanjiId);
      final box = context.findRenderObject()! as RenderBox;
      geometry.value = origin == null
          ? null
          : (
              from: box.globalToLocal(origin.topLeft) & origin.size,
              size: box.size,
            );
    });

    final outline = _Outline(from: geometry.value?.from, progress: progress);

    return Stack(
      clipBehavior: .none,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _CardPainter(
              outline: outline,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        ClipPath(clipper: _OutlineClipper(outline), child: child),
        if (geometry.value case (:final from, :final size) when contentSwap < 1)
          Positioned.fromRect(
            rect: outline.rect(size).topLeft & from.size,
            child: IgnorePointer(
              child: Opacity(
                opacity: 1 - contentSwap,
                child: const KanjiRadicalContent(),
              ),
            ),
          ),
      ],
    );
  }
}

class const _Outline({
  required final Rect? from,
  required final double progress,
}) {
  static const _dialogRadius = 48.0;

  Rect rect(Size size) {
    final to = Offset.zero & size;
    return from == null ? to : Rect.lerp(from, to, progress)!;
  }

  RRect rrect(Size size) {
    Radius radius(double rowRadius) => .circular(
      from == null
          ? _dialogRadius
          : lerpDouble(rowRadius, _dialogRadius, progress)!,
    );

    return .fromRectAndCorners(
      rect(size),
      topLeft: radius(KanjiRadical.topRadius),
      topRight: radius(KanjiRadical.topRadius),
      bottomLeft: radius(KanjiRadical.bottomRadius),
      bottomRight: radius(KanjiRadical.bottomRadius),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _Outline && other.from == from && other.progress == progress;

  @override
  int get hashCode => Object.hash(from, progress);
}

class const _CardPainter({
  required final _Outline outline,
  required final Color color,
}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(outline.rrect(size), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CardPainter old) =>
      old.outline != outline || old.color != color;
}

class const _OutlineClipper(final _Outline outline)
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()..addRRect(outline.rrect(size));

  @override
  bool shouldReclip(_OutlineClipper old) => old.outline != outline;
}

class const _Staggered({
  required final bool open,
  required final int index,
  required final Widget child,
}) extends HookWidget {
  static const _firstDelay = Duration(milliseconds: 80);
  static const _step = Duration(milliseconds: 45);
  static const _rise = 24.0;

  @override
  Widget build(BuildContext context) {
    final arrived = useState(false);
    useEffect(() {
      if (!open) {
        return null;
      }
      final timer = Timer(_firstDelay + _step * index, () {
        arrived.value = true;
      });
      return timer.cancel;
    }, [open]);

    final position = _useSpring(
      arrived.value ? 1 : 0,
      from: 0,
      spring: RadicalHero.openSpring,
      keepVelocity: true,
    );
    final opacity = _useSpring(
      open && arrived.value ? 1 : 0,
      from: 0,
      spring: Springs.expressiveDefaultEffects,
    );

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: .new(0, (1 - position) * _rise),
        child: child,
      ),
    );
  }
}

/// Springs towards [target], starting out at [from].
///
/// With [keepVelocity], a change of target midway turns around smoothly. That
/// lets even a spring with no bounce overshoot, so it's only for values that
/// are free to.
double _useSpring(
  double target, {
  required double from,
  required SpringDescription spring,
  bool keepVelocity = false,
}) {
  final controller = useUnboundedAnimationController(initialValue: from);
  useEffect(() {
    if (controller.value != target) {
      unawaited(
        controller.springTo(
          target,
          spring: spring,
          velocity: keepVelocity ? controller.velocity : 0,
          snapToEnd: true,
        ),
      );
    }
    return null;
  }, [target]);

  return useAnimation(controller);
}
