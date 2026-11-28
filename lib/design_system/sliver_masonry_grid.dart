import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// A vertical sliver that places children of known heights in columns, each
/// child going to the shortest column at the time.
///
/// It fits as many columns as possible while keeping each at least
/// [minCrossAxisExtent] wide.
///
/// The [delegate] has to provide a child for each of the [itemExtents], and
/// every child is forced to its extent. Knowing the extents up front makes
/// the scroll extent exact, and lets a jump to a distant scroll offset build
/// only the children that end up in the viewport.
class const SliverMasonryGrid({
  super.key,
  required super.delegate,
  required final List<double> itemExtents,
  required final double minCrossAxisExtent,
  final double spacing = 0,
}) extends SliverMultiBoxAdaptorWidget {
  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) =>
      _RenderSliverMasonryGrid(
        childManager: context as SliverMultiBoxAdaptorElement,
        itemExtents: itemExtents,
        minCrossAxisExtent: minCrossAxisExtent,
        spacing: spacing,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverMasonryGrid renderObject,
  ) {
    renderObject
      ..itemExtents = itemExtents
      ..minCrossAxisExtent = minCrossAxisExtent
      ..spacing = spacing;
  }
}

class _RenderSliverMasonryGrid({
  required super.childManager,
  required var List<double> _itemExtents,
  required var double _minCrossAxisExtent,
  required var double _spacing,
}) extends RenderSliverMultiBoxAdaptor {
  List<double> get itemExtents => _itemExtents;
  set itemExtents(List<double> value) {
    if (!listEquals(value, _itemExtents)) {
      _itemExtents = value;
      _arrangement = null;
      markNeedsLayout();
    }
  }

  double get minCrossAxisExtent => _minCrossAxisExtent;
  set minCrossAxisExtent(double value) {
    if (value != _minCrossAxisExtent) {
      _minCrossAxisExtent = value;
      markNeedsLayout();
    }
  }

  double get spacing => _spacing;
  set spacing(double value) {
    if (value != _spacing) {
      _spacing = value;
      _arrangement = null;
      markNeedsLayout();
    }
  }

  /// The arrangement from the last layout. It's cleared when the extents or
  /// the spacing change, so it's only out of date if the number of columns
  /// is different.
  _MasonryArrangement? _arrangement;

  var _firstVisibleIndex = 0;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverGridParentData) {
      child.parentData = SliverGridParentData();
    }
  }

  @override
  double childCrossAxisPosition(RenderBox child) =>
      (child.parentData! as SliverGridParentData).crossAxisOffset!;

  @override
  void performLayout() {
    final constraints = this.constraints;
    assert(constraints.axis == .vertical);

    childManager.didStartLayout();

    final count = itemExtents.length;
    if (count == 0) {
      geometry = .zero;
      childManager.didFinishLayout();
      return;
    }

    final columnCount = max(
      constraints.crossAxisExtent ~/ minCrossAxisExtent,
      1,
    );
    final previous = _arrangement;
    final arrangement = _arrangement = previous?.columnCount == columnCount
        ? previous!
        : .new(itemExtents, columnCount, spacing);

    // When the number of columns changes, every child moves. Keep the one
    // that was at the top of the viewport where it was.
    if (previous != null &&
        previous != arrangement &&
        constraints.scrollOffset > 0) {
      final correction =
          arrangement.offsets[_firstVisibleIndex] -
          previous.offsets[_firstVisibleIndex];
      if (correction != 0) {
        geometry = .new(scrollOffsetCorrection: correction);
        return;
      }
    }

    int firstIndexEndingAfter(double offset) => min(
      _firstIndexWhere(count, (index) => arrangement.ends[index] > offset),
      count - 1,
    );

    final cacheStart = constraints.scrollOffset + constraints.cacheOrigin;
    final cacheEnd = cacheStart + constraints.remainingCacheExtent;
    final firstIndex = firstIndexEndingAfter(cacheStart);
    final lastIndex = max(
      _firstIndexWhere(count, (i) => arrangement.offsets[i] >= cacheEnd) - 1,
      firstIndex,
    );

    if (firstChild != null) {
      collectGarbage(
        calculateLeadingGarbage(firstIndex: firstIndex),
        calculateTrailingGarbage(lastIndex: lastIndex),
      );
    }
    if (firstChild == null) {
      addInitialChild(
        index: firstIndex,
        layoutOffset: arrangement.offsets[firstIndex],
      );
    }

    final stride = (constraints.crossAxisExtent + spacing) / columnCount;
    final reversed = axisDirectionIsReversed(constraints.crossAxisDirection);

    BoxConstraints constraintsOf(int index) =>
        .tightFor(width: stride - spacing, height: itemExtents[index]);

    for (var index = indexOf(firstChild!) - 1; index >= firstIndex; index--) {
      insertAndLayoutLeadingChild(constraintsOf(index));
    }

    RenderBox? child;
    for (var index = firstIndex; index <= lastIndex; index++) {
      final next = child == null ? firstChild : childAfter(child);
      child = next != null && indexOf(next) == index
          ? next
          : insertAndLayoutChild(constraintsOf(index), after: child)!;

      final column = arrangement.columns[index];
      child.layout(constraintsOf(index));
      child.parentData! as SliverGridParentData
        ..layoutOffset = arrangement.offsets[index]
        ..crossAxisOffset =
            (reversed ? columnCount - 1 - column : column) * stride;
    }

    _firstVisibleIndex = firstIndexEndingAfter(constraints.scrollOffset);

    final scrollExtent = arrangement.ends.last;
    final leadingOffset = arrangement.offsets[firstIndex];
    final trailingOffset = arrangement.ends[lastIndex];
    geometry = .new(
      scrollExtent: scrollExtent,
      paintExtent: calculatePaintOffset(
        constraints,
        from: leadingOffset,
        to: trailingOffset,
      ),
      cacheExtent: calculateCacheOffset(
        constraints,
        from: leadingOffset,
        to: trailingOffset,
      ),
      maxPaintExtent: scrollExtent,
      hasVisualOverflow: true,
    );
    childManager.didFinishLayout();
  }
}

class _MasonryArrangement(
  List<double> extents,
  final int columnCount,
  double spacing,
) {
  this {
    final nextOffsets = Float64List(columnCount);
    var end = 0.0;

    for (final (index, extent) in extents.indexed) {
      var column = 0;
      for (var i = 1; i < columnCount; i++) {
        if (nextOffsets[i] < nextOffsets[column]) {
          column = i;
        }
      }

      final offset = nextOffsets[column];
      nextOffsets[column] = offset + extent + spacing;

      columns[index] = column;
      offsets[index] = offset;
      ends[index] = end = max(end, offset + extent);
    }
  }

  final columns = Int32List(extents.length);
  final offsets = Float64List(extents.length);
  final ends = Float64List(extents.length);
}

/// The first index below [length] that passes the [test], or [length] if none
/// does. Once an index passes, all the ones after it have to pass as well.
int _firstIndexWhere(int length, bool Function(int index) test) {
  var low = 0;
  var high = length;
  while (low < high) {
    final middle = (low + high) ~/ 2;
    if (test(middle)) {
      high = middle;
    } else {
      low = middle + 1;
    }
  }
  return low;
}
