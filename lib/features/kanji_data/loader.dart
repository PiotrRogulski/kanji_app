import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:logging/logging.dart';

Logger get _logger => Logger('KanjiLoader');

Future<KanjiData> loadKanji() async {
  final stopwatch = Stopwatch()..start();
  final keys = await rootBundle
      .loadString('AssetManifest.json')
      .then((jsonString) => jsonDecode(jsonString) as Map<String, dynamic>)
      .then((json) => json.keys.where((key) => key.startsWith('kanji_data/')));

  final sortedData = await keys
      .map(_loadKanji)
      .wait
      .then((data) => data.nonNulls.sortedBy((e) => e.id));

  final time = stopwatch.elapsed;
  _logger.fine(
    'Loaded ${sortedData.length}/${keys.length} kanji entries in $time',
  );

  return KanjiData(sortedData);
}

Future<KanjiEntry?> _loadKanji(String key) async {
  final String jsonString;
  try {
    jsonString = await rootBundle.loadString(key);
  } catch (err, st) {
    _logger.severe('Failed to load asset for $key', err, st);
    return null;
  }

  final Map<String, dynamic> json;
  try {
    json = jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (err, st) {
    _logger.severe('Failed to decode JSON for $key\n$jsonString', err, st);
    return null;
  }

  try {
    return KanjiEntry.fromJson(json);
  } catch (err, st) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(json);
    _logger.severe('KanjiEntry.fromJson failed for $key\n$prettyJson', err, st);
    return null;
  }
}
