import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/details/widgets/radical_glyph.dart';
import 'package:kanji_app/features/details/widgets/radical_hero.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/routes.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const KanjiRadical(
  final KanjiEntry kanji, {
  required final String form,
  super.key,
}) extends HookWidget {
  static const glyphSize = 36.0;

  static final _rects = <int, List<ValueGetter<Rect?>>>{};

  /// Where the row of [kanjiId] is on the screen. Its dialog grows out of
  /// there, but being a route of its own, it can't reach the row through the
  /// widget tree. If the kanji is open on several pages, it's the top one.
  ///
  /// Only valid once the frame is laid out, so not during a build.
  static Rect? rectOf(int kanjiId) => _rects[kanjiId]?.lastOrNull?.call();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    useEffect(() {
      Rect? rect() {
        final box = context.mounted ? context.findRenderObject() : null;
        return box is RenderBox && box.hasSize
            ? box.localToGlobal(.zero) & box.size
            : null;
      }

      (_rects[kanji.id] ??= []).add(rect);
      return () => _rects[kanji.id]?.remove(rect);
    }, [kanji.id]);

    return Card.filled(
      child: AppInkWell(
        onTap: () => KanjiRadicalRoute(kanji.id).push<void>(context),
        child: KanjiRadicalContent(
          glyph: RadicalHero(
            key: ValueKey(kanji.id),
            kanjiId: kanji.id,
            form: form,
            child: RadicalGlyph.chip(form, theme),
          ),
        ),
      ),
    );
  }
}

class const KanjiRadicalContent({final Widget? glyph, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final contentColor = theme.colorScheme.onSurfaceVariant;

    return AppPadding(
      padding: .only(
        start: AppUnit.small + AppUnit.xsmall,
        end: .xsmall,
        top: .xsmall,
        bottom: .xsmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              s.kanji_radical,
              maxLines: 1,
              overflow: .fade,
              softWrap: false,
              style: theme.textTheme.bodyLarge?.apply(color: contentColor),
            ),
          ),
          SizedBox.square(dimension: KanjiRadical.glyphSize, child: glyph),
          AppIcon(.chevronForward, size: .large, color: contentColor),
        ],
      ),
    );
  }
}
