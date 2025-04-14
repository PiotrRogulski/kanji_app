import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

Future<KanjiData> loadKanji() async {
  final assetsFile = await rootBundle.loadString('AssetManifest.json');
  final assets = jsonDecode(assetsFile) as Map<String, dynamic>;

  final data =
      await assets.keys
          .where((key) => key.startsWith('kanji_data/'))
          // TODO: Load all kanji
          .where(
            (key) => int.parse(key.split('/').last.split('.').first) <= 150,
          )
          .map(_loadKanji)
          .wait;

  return KanjiData(data.sortedBy((e) => e.id));
}

Future<KanjiEntry> _loadKanji(String key) async {
  final jsonString = await rootBundle.loadString(key);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return KanjiEntry.fromJson(json);
}
