import 'package:flutter/widgets.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:kanji_app/extensions.dart';
import 'package:kanji_app/features/kanji_data/kanji_data.dart';

final _queryByID = RegExp(r'^#?(?<id>[0-9０-９]+)$');
final _japaneseOnly = RegExp(
  r'^[\p{Script=Han}\p{Script=Hiragana}\p{Script=Katakana}]+$',
  unicode: true,
);
final _middleDot = RegExp('[・･]');

const _kanaKit = KanaKit();

String _stripMiddleDots(String s) => s.replaceAll(_middleDot, '');

int? _idFromQuery(String query) => _queryByID
    .firstMatch(query)
    ?.namedGroup('id')
    ?.codeUnits
    .map(
      (c) => switch (c) {
        >= 0xff10 && <= 0xff19 => c - 0xff10,
        _ => c - 0x30,
      },
    )
    .join()
    .apply(int.tryParse);

SearchMatch matchEntry(KanjiEntry entry, String rawQuery) {
  final query = _Query(rawQuery);
  if (query.id case final id?) {
    if (entry.id == id) {
      return .id;
    } else {
      return .none;
    }
  }

  if (query.matchesKanji(entry.kanji)) {
    return .kanji;
  }

  for (final r in entry.readings.map(_stripMiddleDots)) {
    if (query.matchesFully(r)) {
      return .fullReading;
    }
    if (query.matchesPartially(r)) {
      return .partialReading;
    }
  }
  final allWords = [
    ...entry.wordsRequiredNow,
    ...entry.wordsRequiredLater,
    ...entry.additionalWords,
  ];

  for (final word in allWords) {
    final kanji = _stripMiddleDots(word.kanji);
    if (query.matchesKanji(kanji)) {
      return .wordKanji;
    }

    final reading = _stripMiddleDots(word.reading);
    if (reading.isNotEmpty) {
      if (query.matchesFully(reading)) {
        return .wordFullReading;
      }
      if (query.matchesPartially(reading)) {
        return .wordPartialReading;
      }
    }

    if (query.matchesLatinText(word.meaning)) {
      return .wordMeaning;
    }
  }

  return .none;
}

enum SearchMatch implements Comparable<SearchMatch> {
  id,
  kanji,
  fullReading,
  partialReading,
  wordKanji,
  wordFullReading,
  wordPartialReading,
  wordMeaning,
  none;

  @override
  int compareTo(SearchMatch other) => index.compareTo(other.index);
}

class _Query {
  _Query(this._rawQuery);

  final String _rawQuery;
  late final query = _stripMiddleDots(_rawQuery);
  late final id = _idFromQuery(_rawQuery);
  late final hira = _stripMiddleDots(_kanaKit.toHiragana(_rawQuery));
  late final kata = _stripMiddleDots(_kanaKit.toKatakana(_rawQuery));
  late final lower = query.toLowerCase();

  bool matchesKanji(String text) =>
      _japaneseOnly.hasMatch(query) && query.characters.contains(text);
  bool matchesFully(String text) =>
      text == query || text == hira || text == kata;
  bool matchesPartially(String text) =>
      text.contains(query) || text.contains(hira) || text.contains(kata);
  bool matchesLatinText(String text) => text.toLowerCase().contains(lower);
}
