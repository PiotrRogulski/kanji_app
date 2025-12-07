import 'package:cached_query_flutter/cached_query_flutter.dart' show Query;
import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/grid_painter.dart';
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
      clipBehavior: .antiAlias,
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
    final theme = Theme.of(context);

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
                color: theme.colorScheme.onSurface,
              ),
              Text(
                s.kanjiDetails_strokeOrderNotAvailable,
                style: theme.textTheme.titleLarge,
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
                ..style = .stroke
                ..color = colorScheme.onSurfaceVariant
                ..strokeWidth = 2
                ..strokeCap = .round,
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
      painter: KanjiGridPainter(colorScheme: theme.colorScheme),
      child: child,
    );
  }
}
