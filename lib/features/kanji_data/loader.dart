import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:logging/logging.dart';

Logger get _logger => Logger('KanjiLoader');

Future<KanjiData> loadKanji() async {
  final assetsFile = await rootBundle.loadString('AssetManifest.json');
  final assets = jsonDecode(assetsFile) as Map<String, dynamic>;

  final data = await assets.keys
      .where((key) => key.startsWith('kanji_data/'))
      // TODO: Load all kanji
      .where((key) => int.parse(key.split('/').last.split('.').first) <= 350)
      .map(_loadKanji)
      .wait;

  final sortedData = data.nonNulls.sortedBy((e) => e.id);

  _logger.fine('Loaded ${sortedData.length}/${data.length} kanji entries');

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
