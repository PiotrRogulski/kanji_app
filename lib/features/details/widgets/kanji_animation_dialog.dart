import 'package:cached_query_flutter/cached_query_flutter.dart' show Query;
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/kanji_api.dart';
import 'package:kanji_app/query/use_query.dart';
import 'package:kanji_app/svg_drawing_animation.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class KanjiAnimationDialog extends StatelessWidget {
  const KanjiAnimationDialog(this.kanji, {super.key});

  final String kanji;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.circular(.xlarge) * 1.5,
        ),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: AppPadding(
        padding: const .all(.large),
        child: _KanjiDetailsBody(kanji),
      ),
    );
  }
}

class _KanjiDetailsBody extends HookWidget {
  _KanjiDetailsBody(this.kanji) : super(key: GlobalObjectKey(kanji));

  final String kanji;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);

    final kanjiApi = context.read<KanjiApi>();

    final (result, _) = useQuery(
      Query(key: 'kanjiSvg-$kanji', queryFn: () => kanjiApi.kanjiSvg(kanji)),
    );

    return switch (result) {
      QueryLoading() => const Center(child: CircularProgressIndicator()),
      QuerySuccess(:final value) => _KanjiDetailsLoaded(value),
      QueryFailure() => FittedBox(
        fit: .scaleDown,
        child: Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              AppIcon(
                .indeterminateQuestionBox,
                size: AppUnit.xlarge * 6,
                weight: .light,
                color: colorScheme.onSurface,
              ),
              Text(
                s.kanjiDetails_strokeOrderNotAvailable,
                style: textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    };
  }
}

class _KanjiDetailsLoaded extends HookWidget {
  const _KanjiDetailsLoaded(this.svg);

  final String svg;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final controller = useSvgController(
      svg,
      startDelay: const Duration(milliseconds: 1000),
      speed: 0.1,
      delayBetweenStrokes: const Duration(milliseconds: 200),
      strokeAnimationCurve: Curves.easeInOut,
    );

    useEffect(() {
      controller.loop();
      return null;
    }, [controller]);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: _KanjiGrid(
            child: SvgDrawingAnimation(
              controller: controller,
              strokePaint: Paint()
                ..style = PaintingStyle.stroke
                ..color = colorScheme.onSurfaceVariant
                ..strokeWidth = 2
                ..strokeCap = StrokeCap.round,
              pen: Pen(
                radius: 4,
                paint: Paint()
                  ..color = colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KanjiGrid extends StatelessWidget {
  const _KanjiGrid({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _KanjiGridPainter(colorScheme: theme.colorScheme),
      child: child,
    );
  }
}

class _KanjiGridPainter extends CustomPainter {
  _KanjiGridPainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.longestSide;

    final unit = side / 100;
    final color = colorScheme.outlineVariant;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = unit
      ..style = .stroke;
    final dashedLinePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = unit / 2
      ..style = .stroke;
    final dashLength = unit * 4;
    final gapLength = unit * 2;

    void drawDashedLine(Offset p1, Offset p2) {
      final delta = p2 - p1;
      final totalLength = delta.distance;

      final direction = delta / totalLength;

      var distanceTraveled = 0.0;
      while (distanceTraveled < totalLength) {
        final start = p1 + direction * distanceTraveled;
        final endDistance = (distanceTraveled + dashLength).clamp(
          0,
          totalLength,
        );
        final end = p1 + direction * endDistance.toDouble();
        canvas.drawLine(start, end, dashedLinePaint);
        distanceTraveled += dashLength + gapLength;
      }
    }

    const radius = Radius.circular(AppUnit.xlarge);
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, radius);
    canvas
      ..drawRRect(rrect, Paint()..color = colorScheme.surfaceContainerLowest)
      ..drawRRect(rrect, borderPaint);

    drawDashedLine(rect.centerLeft, rect.centerRight);
    drawDashedLine(rect.topCenter, rect.bottomCenter);
  }

  @override
  bool shouldRepaint(_KanjiGridPainter oldDelegate) =>
      colorScheme != oldDelegate.colorScheme;
}
