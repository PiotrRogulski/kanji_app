import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          borderRadius: AppBorderRadius.circular(AppUnit.xlarge),
        ),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const AppPadding.all(AppUnit.large),
            child: _KanjiDetailsBody(kanji),
          ),
          PositionedDirectional(
            top: AppUnit.xsmall,
            end: AppUnit.xsmall,
            child: IconButton(
              icon: const AppIcon(AppIconData.close, size: AppUnit.xlarge),
              onPressed: context.pop,
              padding: const AppPadding.all(AppUnit.medium),
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

    final result = useFuture(
      useMemoized(
        () => Query(
          key: 'kanjiSvg-$kanji',
          queryFn: () => kanjiApi.kanjiSvg(kanji),
        ).fetch(),
        [kanji],
      ),
    ).data;

    return switch (result) {
      null => const Center(child: CircularProgressIndicator()),
      QuerySuccess(:final value) => _KanjiDetailsLoaded(value),
      QueryFailure() => FittedBox(
        fit: BoxFit.scaleDown,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                AppIconData.indeterminateQuestionBox,
                size: 196,
                weight: AppDynamicWeight.light,
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
