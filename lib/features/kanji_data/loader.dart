import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';
import 'package:kanji_app/features/kanji_data/radicals_data.dart';
import 'package:logging/logging.dart';

Future<KanjiData> loadKanji() => _load(
  asset: 'assets/kanji.jsonl.xz',
  fromJson: KanjiEntry.fromJson,
  create: KanjiData.new,
  entryId: (e) => e.id,
  loggerName: 'KanjiLoader',
);

Future<RadicalsData> loadRadicals() => _load(
  asset: 'assets/radicals.jsonl.xz',
  fromJson: RadicalEntry.fromJson,
  create: RadicalsData.new,
  entryId: (e) => e.id,
  loggerName: 'RadicalLoader',
);

Future<T> _load<T, TEntry>({
  required String asset,
  required TEntry Function(Map<String, dynamic> json) fromJson,
  required T Function(List<TEntry> entries) create,
  required int Function(TEntry entry) entryId,
  required String loggerName,
}) async {
  final logger = Logger(loggerName);
  final stopwatch = Stopwatch()..start();

  final assetBytes = await rootBundle.load(asset);

  final jsons = assetBytes
      .apply(Uint8List.sublistView)
      .apply(XZDecoder().decodeBytes)
      .apply(utf8.decode)
      .trimRight()
      .split('\n');

  final data = jsons
      .map((jsonString) => _parseEntry(jsonString, fromJson, logger))
      .nonNulls
      .cast<TEntry>()
      .sortedBy(entryId);

  final time = stopwatch.elapsed;
  logger.fine('Loaded ${data.length}/${jsons.length} entries in $time');

  return create(data);
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
