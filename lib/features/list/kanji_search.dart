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
  final query = _stripMiddleDots(rawQuery);
  if (_idFromQuery(query) case final id?) {
    if (entry.id == id) {
      return .id;
    } else {
      return .none;
    }
  }

  if (_japaneseOnly.hasMatch(query) && query.characters.contains(entry.kanji)) {
    return .kanji;
  }

  final hira = _stripMiddleDots(_kanaKit.toHiragana(query));
  final kata = _stripMiddleDots(_kanaKit.toKatakana(query));

  for (final r in entry.readings.map(_stripMiddleDots)) {
    if (r == query || r == hira || r == kata) {
      return .fullReading;
    }
    if (r.contains(query) || r.contains(hira) || r.contains(kata)) {
      return .partialReading;
    }
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
