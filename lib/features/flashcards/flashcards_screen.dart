import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/navigation/app_coordinator.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

enum FlashcardMode { kanji, words, mixed }

class FlashcardsScreen extends HookWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    final kanjiData = context.watch<KanjiData>();

    final rangeStart = useState(kanjiData.entries.first.id);
    final rangeEnd = useState(kanjiData.entries.last.id);

    final startController = useTextEditingController(
      text: rangeStart.value.toString(),
    );
    final endController = useTextEditingController(
      text: rangeEnd.value.toString(),
    );

    final selectedMode = useState(FlashcardMode.kanji);

    final scrollController = useScrollController();

    final isValid = rangeStart.value <= rangeEnd.value;

    return AppBigTitleScaffold(
      title: s.flashcards_title,
      scrollController: scrollController,
      showScrollToTopFab: false,
      bottomChild: FilledButton(
        onPressed: isValid
            ? () => AppCoordinator.instance.toFlashcardsPlay(
                rangeStart.value,
                rangeEnd.value,
                selectedMode.value,
              )
            : null,
        child: Text(s.flashcards_start),
      ),
      slivers: [
        AppUnit.medium.sliverGap,
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                s.flashcards_selectRange,
                style: theme.textTheme.titleMedium,
              ),
              AppUnit.small.gap,
              Row(
                children: [
                  Expanded(
                    child: _RangeTextField(
                      controller: startController,
                      labelText: s.flashcards_rangeStart,
                      helperText: s.flashcards_min(kanjiData.entries.first.id),
                      errorText: !isValid && rangeStart.value > rangeEnd.value
                          ? s.flashcards_errorStartTooHigh
                          : null,
                      onChanged: (value) {
                        if (int.tryParse(value) case final intValue?) {
                          rangeStart.value = intValue;
                        }
                      },
                      isStart: true,
                    ),
                  ),
                  AppUnit.tiny.gap,
                  Expanded(
                    child: _RangeTextField(
                      controller: endController,
                      labelText: s.flashcards_rangeEnd,
                      helperText: s.flashcards_max(kanjiData.entries.last.id),
                      errorText: !isValid && rangeEnd.value < rangeStart.value
                          ? s.flashcards_errorEndTooLow
                          : null,
                      onChanged: (value) {
                        if (int.tryParse(value) case final intValue?) {
                          rangeEnd.value = intValue;
                        }
                      },
                      isStart: false,
                    ),
                  ),
                ],
              ),
              AppUnit.large.gap,
              Text(s.flashcards_mode, style: theme.textTheme.titleMedium),
              AppUnit.small.gap,
              AppConnectedButtonGroup<FlashcardMode>(
                segments: [
                  .new(value: .kanji, label: s.flashcards_modeKanji),
                  .new(value: .words, label: s.flashcards_modeWords),
                  .new(value: .mixed, label: s.flashcards_modeMixed),
                ],
                selected: selectedMode.value,
                onSelectionChanged: (value) => selectedMode.value = value,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RangeTextField extends StatelessWidget {
  const _RangeTextField({
    required this.controller,
    required this.labelText,
    required this.helperText,
    this.errorText,
    required this.onChanged,
    required this.isStart,
  });

  final TextEditingController controller;
  final String labelText;
  final String helperText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    final delegate = _RangeTextFieldLayoutDelegate(
      context: context,
      isStart: isStart,
      controller: controller,
      labelText: labelText,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = delegate._computeIntrinsicHeight(constraints.maxWidth);
        return CustomSingleChildLayout(
          delegate: delegate,
          child: delegate._buildTextField(height),
        );
      },
    );
  }
}

class _RangeTextFieldLayoutDelegate extends SingleChildLayoutDelegate {
  _RangeTextFieldLayoutDelegate({
    required this.context,
    required this.isStart,
    required this.controller,
    required this.labelText,
    required this.helperText,
    this.errorText,
    required this.onChanged,
  });

  final BuildContext context;
  final bool isStart;
  final TextEditingController controller;
  final String labelText;
  final String helperText;
  final String? errorText;
  final ValueChanged<String> onChanged;

  double? _cachedHeight;
  double? _cachedWidth;

  double _computeIntrinsicHeight(double width) {
    if (_cachedHeight != null && _cachedWidth == width) {
      return _cachedHeight!;
    }

    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.titleSmall;
    final helperStyle = theme.textTheme.bodySmall;

    const contentPadding = 32.0;

    final labelHeight = (labelStyle?.fontSize ?? 14.0) + 4.0;

    final hasHelper = helperText.isNotEmpty || errorText != null;
    final helperHeight = hasHelper
        ? (helperStyle?.fontSize ?? 12.0) + 8.0
        : 0.0;

    const minInputHeight = 24.0;

    final height = labelHeight + contentPadding + minInputHeight + helperHeight;

    _cachedHeight = height;
    _cachedWidth = width;
    return height;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    final height = _computeIntrinsicHeight(constraints.maxWidth);
    return Size(constraints.maxWidth, height);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final height = _computeIntrinsicHeight(constraints.maxWidth);
    return BoxConstraints.tightFor(width: constraints.maxWidth, height: height);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset.zero;
  }

  Widget _buildTextField(double height) {
    final theme = Theme.of(context);
    const fixedRadius = AppUnit.small;
    final stadiumRadius = height / 2;

    final borderRadius = isStart
        ? BorderRadiusDirectional.horizontal(
            start: .circular(stadiumRadius),
            end: const .circular(fixedRadius),
          )
        : BorderRadiusDirectional.horizontal(
            start: const .circular(fixedRadius),
            end: .circular(stadiumRadius),
          );

    return TextFormField(
      controller: controller,
      keyboardType: .number,
      style: theme.textTheme.titleMedium,
      decoration: .new(
        labelText: labelText,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: _RangeInputBorder(
          borderSide: const .new(color: Colors.transparent, width: 0),
          borderRadius: borderRadius,
        ),
        enabledBorder: _RangeInputBorder(
          borderSide: const .new(color: Colors.transparent, width: 0),
          borderRadius: borderRadius,
        ),
        focusedBorder: _RangeInputBorder(
          borderSide: .new(color: theme.colorScheme.primary, width: 4),
          borderRadius: borderRadius,
        ),
        errorBorder: _RangeInputBorder(
          borderSide: .new(color: theme.colorScheme.error, width: 4),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: _RangeInputBorder(
          borderSide: .new(color: theme.colorScheme.error, width: 4),
          borderRadius: borderRadius,
        ),
        contentPadding: const .symmetric(horizontal: 16, vertical: 16),
        helperText: helperText,
        helperStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  @override
  bool shouldRelayout(_RangeTextFieldLayoutDelegate oldDelegate) {
    final needsRelayout =
        oldDelegate.isStart != isStart ||
        oldDelegate.labelText != labelText ||
        oldDelegate.helperText != helperText ||
        oldDelegate.errorText != errorText;
    if (needsRelayout) {
      _cachedHeight = null;
      _cachedWidth = null;
    }
    return needsRelayout;
  }
}

class _RangeInputBorder extends InputBorder {
  const _RangeInputBorder({
    required super.borderSide,
    required this.borderRadius,
  });

  final BorderRadiusDirectional borderRadius;

  @override
  bool get isOutline => false;

  @override
  _RangeInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadiusDirectional? borderRadius,
  }) => .new(
    borderSide: borderSide ?? this.borderSide,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  @override
  EdgeInsetsGeometry get dimensions => .all(borderSide.width);

  @override
  _RangeInputBorder scale(double t) =>
      .new(borderSide: borderSide.scale(t), borderRadius: borderRadius * t);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a case final _RangeInputBorder other) {
      return _RangeInputBorder(
        borderSide: .lerp(other.borderSide, borderSide, t),
        borderRadius: .lerp(other.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b case final _RangeInputBorder other) {
      return _RangeInputBorder(
        borderSide: .lerp(borderSide, other.borderSide, t),
        borderRadius: .lerp(borderRadius, other.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => .new()
    ..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(0));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => .new()
    ..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(0));

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);

    canvas.drawRRect(
      borderRadius.resolve(textDirection).toRRect(rect),
      borderSide.toPaint()..strokeCap = .round,
    );
  }
}
