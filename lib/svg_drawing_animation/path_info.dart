import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class const PathInfo({
  required final List<Path> paths,
  required final List<double> partLengths,
  required final Size size,
});

PathInfo pathInfoFromSvg(String svg) {
  final document = XmlDocument.parse(svg);

  final paths = document
      // That's okay
      // ignore: experimental_member_use
      .xpathEvaluate('//path/@d')
      .nodes
      .map((e) => e.value)
      .nonNulls
      .map(parseSvgPath)
      .toList();

  final [_, _, viewBoxWidth, viewBoxHeight] = document
      // That's okay
      // ignore: experimental_member_use
      .xpathEvaluate('/svg/@viewBox')
      .string
      .split(' ');

  final partLengths = paths
      .map((p) => p.computeMetrics().map((m) => m.length).sum)
      .toList();

  return .new(
    paths: paths,
    partLengths: partLengths,
    size: .new(.parse(viewBoxWidth), .parse(viewBoxHeight)),
  );
}
