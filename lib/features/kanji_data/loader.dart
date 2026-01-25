import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:logging/logging.dart';

Future<KanjiData> loadKanji() => _loadEntries(
  asset: 'assets/kanji.jsonl',
  fromJson: KanjiEntry.fromJson,
  entryId: (e) => e.id,
).then(KanjiData.new);

Future<RadicalsData> loadRadicals() => _loadEntries(
  asset: 'assets/radicals.jsonl',
  fromJson: RadicalEntry.fromJson,
  entryId: (e) => e.id,
).then(RadicalsData.new);

Future<List<TEntry>> _loadEntries<TEntry extends Object>({
  required String asset,
  required TEntry Function(Map<String, dynamic> json) fromJson,
  required int Function(TEntry entry) entryId,
}) async {
  final logger = Logger('Loader $asset');
  final stopwatch = Stopwatch()..start();

  final jsons = (await rootBundle.loadString(asset)).trimRight().split('\n');

  final data = jsons
      .map((jsonString) => _parseEntry(jsonString, fromJson, logger))
      .nonNulls
      .sortedBy(entryId);

  final time = stopwatch.elapsed;
  logger.fine('Loaded ${data.length}/${jsons.length} entries in $time');

  return data;
}

TEntry? _parseEntry<TEntry>(
  String jsonString,
  TEntry Function(Map<String, dynamic> json) fromJson,
  Logger logger,
) {
  final Map<String, dynamic> json;
  try {
    json = jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (err, st) {
    logger.severe('Failed to decode JSON\n$jsonString', err, st);
    return null;
  }
  try {
    return fromJson(json);
  } catch (err, st) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(json);
    logger.severe('fromJson failed\n$prettyJson', err, st);
    return null;
  }
}
