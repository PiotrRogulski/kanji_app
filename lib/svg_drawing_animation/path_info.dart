import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';

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
  final paths = XmlDocument.parse(svg)
      .findAllElements('path')
      .map((e) => e.getAttribute('d'))
      .nonNulls
      .map(parseSvgPath);

  final path = paths.fold(Path(), (path, e) => path..addPath(e, Offset.zero));
  final bounds = path.getBounds();
  final topLeft = bounds.topLeft;

  final partLengths = paths
      .map((p) => p.computeMetrics().map((m) => m.length).sum)
      .toList();

  return PathInfo(
    paths: [
      for (final p in paths)
        p.transform(
          Matrix4.translationValues(-topLeft.dx, -topLeft.dy, 0).storage,
        ),
    ],
    partLengths: partLengths,
    size: bounds.size,
  );
}
