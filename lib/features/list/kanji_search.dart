import 'package:flutter/widgets.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

final _queryByID = RegExp(r'^#?(?<id>\d+)$');
final _japaneseOnly = RegExp(
  r'^[\p{Script=Han}\p{Script=Hiragana}\p{Script=Katakana}]+$',
  unicode: true,
);

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

  if (entry.readings.onyomi.contains(query) ||
      entry.readings.kunyomi.contains(query)) {
    return .fullReading;
  }

  if (entry.readings.onyomi.any((r) => r.contains(query)) ||
      entry.readings.kunyomi.any((r) => r.contains(query))) {
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
