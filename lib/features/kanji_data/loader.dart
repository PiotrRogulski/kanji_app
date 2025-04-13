import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

Future<List<KanjiData>> loadKanji() async {
  final assetsFile = await rootBundle.loadString('AssetManifest.json');
  final assets = jsonDecode(assetsFile) as Map<String, dynamic>;

  return assets.keys
      .where((key) => key.startsWith('kanji_data/'))
      // TODO: Load all kanji
      .where((key) => int.parse(key.split('/').last.split('.').first) <= 150)
      .map(_loadKanji)
      .wait;
}

Future<KanjiData> _loadKanji(String key) async {
  final jsonString = await rootBundle.loadString(key);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return KanjiData.fromJson(json);
}
