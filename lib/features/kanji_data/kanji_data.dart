import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class KanjiData {
  const KanjiData(this.entries);

  final List<KanjiEntry> entries;

  KanjiEntry? get(int id) => entries.firstWhereOrNull((e) => e.id == id);
}

class KanjiEntry with EquatableMixin {
  const KanjiEntry({
    required this.id,
    required this.kanji,
    required this.readings,
    required this.wordsRequiredNow,
    required this.wordsRequiredLater,
    required this.additionalWords,
  });

  KanjiEntry.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      kanji = json['kanji'] as String,
      readings = ((json['readings'] as List?) ?? []).cast(),
      wordsRequiredNow = ((json['wordsRequiredNow'] as List?) ?? [])
          .cast<Map<String, dynamic>>()
          .map(KanjiWord.fromJson)
          .toList(),
      wordsRequiredLater = ((json['wordsRequiredLater'] as List?) ?? [])
          .cast<Map<String, dynamic>>()
          .map(KanjiWord.fromJson)
          .toList(),
      additionalWords = ((json['additionalWords'] as List?) ?? [])
          .cast<Map<String, dynamic>>()
          .map(KanjiWord.fromJson)
          .toList();

  final int id;
  final String kanji;
  final List<String> readings;
  final List<KanjiWord> wordsRequiredNow;
  final List<KanjiWord> wordsRequiredLater;
  final List<KanjiWord> additionalWords;

  @override
  List<Object?> get props => [
    id,
    kanji,
    readings,
    wordsRequiredNow,
    wordsRequiredLater,
    additionalWords,
  ];
}

class KanjiWord with EquatableMixin {
  const KanjiWord({
    required this.kanji,
    required this.reading,
    required this.meaning,
    this.reference,
  });

  KanjiWord.fromJson(Map<String, dynamic> json)
    : kanji = (json['kanji'] ?? '').toString(),
      reading = (json['reading'] ?? '').toString(),
      meaning = (json['meaning'] ?? '').toString(),
      reference = json['reference'] as int?;

  final String kanji;
  final String reading;
  final String meaning;
  final int? reference;

  @override
  List<Object?> get props => [kanji, reading, meaning, reference];
}
