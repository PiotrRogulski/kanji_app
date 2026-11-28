import 'package:kanji_app/common/use_spring.dart';
import 'package:kanji_app/design_system.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const DynamicWeightText(
  final String data, {
  super.key,
  required final TextStyle? style,
  final AppDynamicWeight? weight,
  final TextAlign? textAlign,
  final int? maxLines,
  final TextOverflow? overflow,
  final bool? softWrap,
  final bool reserveBoldWidth = true,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final style = this.style ?? DefaultTextStyle.of(context).style;

    final dynamicWeight = weight ?? DynamicWeight.maybeOf(context)?.weight;
    final fontWeight = useValueSpring(
      dynamicWeight?.value ?? (style.fontWeight ?? .normal).value.toDouble(),
    );

    Widget text(double fontWeight) => Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: style.copyWith(
        fontVariations: [
          for (final variation in style.fontVariations ?? <FontVariation>[])
            if (variation.axis != 'wght') variation,
          .weight(fontWeight),
        ],
      ),
    );

    if (dynamicWeight == null || !reserveBoldWidth) {
      return text(fontWeight);
    }

    return Stack(
      alignment: switch (textAlign) {
        .center => .center,
        .end || .right => .centerEnd,
        _ => .centerStart,
      },
      children: [
        ExcludeSemantics(
          child: Opacity(opacity: 0, child: text(AppDynamicWeight.bold.value)),
        ),
        text(fontWeight),
      ],
    );
  }
}
