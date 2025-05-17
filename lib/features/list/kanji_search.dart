import 'package:flutter/widgets.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

final _kanjiRegex = RegExp(r'^\p{Script=Han}+$', unicode: true);

// TODO: search more fuzzily
SearchMatch matchEntry(KanjiEntry entry, String query) {
  if (_kanjiRegex.hasMatch(query) && query.characters.contains(entry.kanji)) {
    return SearchMatch.kanji;
  }

  if (entry.readings.onyomi.contains(query) ||
      entry.readings.kunyomi.contains(query)) {
    return SearchMatch.fullReading;
  }

  if (entry.readings.onyomi.any((r) => r.contains(query)) ||
      entry.readings.kunyomi.any((r) => r.contains(query))) {
    return SearchMatch.partialReading;
  }

  return SearchMatch.none;
}

enum SearchMatch implements Comparable<SearchMatch> {
  kanji,
  fullReading,
  partialReading,
  none;

  @override
  int compareTo(SearchMatch other) => index.compareTo(other.index);
}
