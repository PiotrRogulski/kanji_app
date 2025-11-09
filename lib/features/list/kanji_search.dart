import 'package:flutter/widgets.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

final _queryByID = RegExp(r'^#?(?<id>\d+)$');
final _japaneseOnly = RegExp(
  r'^[\p{Script=Han}\p{Script=Hiragana}\p{Script=Katakana}]+$',
  unicode: true,
);

const _kanaKit = KanaKit();

// TODO: search more fuzzily
SearchMatch matchEntry(KanjiEntry entry, String query) {
  if (_queryByID.firstMatch(query) case final match?) {
    final id = int.parse(match.namedGroup('id')!);
    if (entry.id == id) {
      return .id;
    } else {
      return .none;
    }
  }

  if (_japaneseOnly.hasMatch(query) && query.characters.contains(entry.kanji)) {
    return .kanji;
  }

  final hira = _kanaKit.toHiragana(query);
  final kata = _kanaKit.toKatakana(query);

  if (entry.readings.contains(query) ||
      entry.readings.contains(hira) ||
      entry.readings.contains(kata)) {
    return .fullReading;
  }

  if (entry.readings.any(
    (r) => r.contains(query) || r.contains(hira) || r.contains(kata),
  )) {
    return .partialReading;
  }

  return .none;
}

enum SearchMatch implements Comparable<SearchMatch> {
  id,
  kanji,
  fullReading,
  partialReading,
  none;

  @override
  int compareTo(SearchMatch other) => index.compareTo(other.index);
}
