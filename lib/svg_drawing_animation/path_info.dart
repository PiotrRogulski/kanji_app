import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class PathInfo {
  const PathInfo({
    required this.paths,
    required this.partLengths,
    required this.size,
  });

  final List<Path> paths;
  final List<double> partLengths;
  final Size size;
}

PathInfo pathInfoFromSvg(String svg) {
  final document = XmlDocument.parse(svg);

  final paths = document
      .xpathEvaluate('//path/@d')
      .nodes
      .map((e) => e.value)
      .nonNulls
      .map(parseSvgPath)
      .toList();

  final [_, _, viewBoxWidth, viewBoxHeight] = document
      .xpathEvaluate('/svg/@viewBox')
      .string
      .split(' ');

  final partLengths = paths
      .map((p) => p.computeMetrics().map((m) => m.length).sum)
      .toList();

  return PathInfo(
    paths: paths,
    partLengths: partLengths,
    size: .new(.parse(viewBoxWidth), .parse(viewBoxHeight)),
  );
}
