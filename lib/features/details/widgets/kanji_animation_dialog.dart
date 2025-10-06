import 'package:cached_query_flutter/cached_query_flutter.dart' show Query;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/kanji_api.dart';
import 'package:kanji_app/query/use_query.dart';
import 'package:kanji_app/svg_drawing_animation.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

// FIXME: replace
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
          borderRadius: AppBorderRadius.circular(.xlarge),
        ),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppPadding(
            padding: const .all(.large),
            child: _KanjiDetailsBody(kanji),
          ),
          PositionedDirectional(
            top: AppUnit.xsmall,
            end: AppUnit.xsmall,
            child: IconButton(
              icon: const AppIcon(.close, size: .xlarge),
              onPressed: context.pop,
              padding: const AppEdgeInsets.all(.medium),
            ),
          ),
        ],
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
    final colorScheme = ColorScheme.of(context);

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
          child: Padding(
            padding: EdgeInsets.all(constraints.biggest.shortestSide * 0.1),
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
