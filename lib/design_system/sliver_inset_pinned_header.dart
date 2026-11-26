import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// A header that scrolls with the slivers around it until it's [inset] away
/// from the start of the viewport, and stays there.
///
/// A [PinnedHeaderSliver] would stop at the very start of the viewport, which
/// is under the status bar.
class const SliverInsetPinnedHeader({
  super.key,
  required final double inset,
  required Widget super.child,
}) extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverInsetPinnedHeader(inset);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverInsetPinnedHeader renderObject,
  ) {
    renderObject.inset = inset;
  }
}

class _RenderSliverInsetPinnedHeader(var double _inset)
    extends RenderSliverSingleBoxAdapter {
  double get inset => _inset;
  set inset(double value) {
    if (value != _inset) {
      _inset = value;
      markNeedsLayout();
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) => 0;

  @override
  void performLayout() {
    final constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = switch (constraints.axis) {
      .vertical => child!.size.height,
      .horizontal => child!.size.width,
    };

    // Where the header would be in the viewport if it just scrolled along.
    // While it's in there, the paint extent that's left says how far it is.
    final position = constraints.scrollOffset > 0
        ? -constraints.scrollOffset
        : constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
    final paintOrigin = max<double>(0, inset - max(position, 0));

    final layoutExtent = clampDouble(
      childExtent - constraints.scrollOffset,
      0,
      constraints.remainingPaintExtent,
    );

    geometry = .new(
      scrollExtent: childExtent,
      paintOrigin: paintOrigin,
      paintExtent: clampDouble(
        constraints.remainingPaintExtent - paintOrigin,
        layoutExtent,
        max(childExtent, layoutExtent),
      ),
      layoutExtent: layoutExtent,
      maxPaintExtent: childExtent + inset,
      maxScrollObstructionExtent: childExtent + inset,
      cacheExtent: calculateCacheOffset(constraints, from: 0, to: childExtent),
      hasVisualOverflow: true,
    );
  }
}
