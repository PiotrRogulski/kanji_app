import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:logging/logging.dart';

Logger get _logger => Logger('KanjiLoader');

Future<KanjiData> loadKanji() async {
  final stopwatch = Stopwatch()..start();

  final assetBytes = await rootBundle.load('assets/kanji.jsonl.xz');

  final jsons = assetBytes
      .apply(Uint8List.sublistView)
      .apply(XZDecoder().decodeBytes)
      .apply(utf8.decode)
      .trimRight()
      .split('\n');

  final data = jsons.map(_parseKanji).nonNulls.sortedBy((e) => e.id);

  final time = stopwatch.elapsed;
  _logger.fine('Loaded ${data.length}/${jsons.length} kanji entries in $time');

  return KanjiData(data);
}

KanjiEntry? _parseKanji(String jsonString) {
  final Map<String, dynamic> json;
  try {
    json = jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (err, st) {
    _logger.severe('Failed to decode JSON\n$jsonString', err, st);
    return null;
  }

  try {
    return KanjiEntry.fromJson(json);
  } catch (err, st) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(json);
    _logger.severe('KanjiEntry.fromJson failed\n$prettyJson', err, st);
    return null;
  }
}
