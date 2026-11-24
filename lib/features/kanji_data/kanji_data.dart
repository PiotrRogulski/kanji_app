import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class const KanjiData(final List<KanjiEntry> entries) {
  KanjiEntry? get(int id) => entries.firstWhereOrNull((e) => e.id == id);
}

class const KanjiEntry({
  required final int id,
  required final String kanji,
  required final String meaning,
  final int? radical,
  final String? radicalForm,
  required final List<String> readings,
  required final List<KanjiWord> wordsRequiredNow,
  required final List<KanjiWord> wordsRequiredLater,
  required final List<KanjiWord> additionalWords,
}) with Equatable {
  new fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] as int,
        kanji: json['kanji'] as String,
        meaning: json['meaning'] as String,
        radical: json['radical'] as int?,
        radicalForm: json['radicalForm'] as String?,
        readings: ((json['readings'] as List?) ?? []).cast(),
        wordsRequiredNow: ((json['wordsRequiredNow'] as List?) ?? [])
            .cast<Map<String, dynamic>>()
            .map(KanjiWord.fromJson)
            .toList(),
        wordsRequiredLater: ((json['wordsRequiredLater'] as List?) ?? [])
            .cast<Map<String, dynamic>>()
            .map(KanjiWord.fromJson)
            .toList(),
        additionalWords: ((json['additionalWords'] as List?) ?? [])
            .cast<Map<String, dynamic>>()
            .map(KanjiWord.fromJson)
            .toList(),
      );

  @override
  List<Object?> get props => [
    id,
    kanji,
    meaning,
    radical,
    radicalForm,
    readings,
    wordsRequiredNow,
    wordsRequiredLater,
    additionalWords,
  ];
}

class const KanjiWord({
  required final String kanji,
  required final String reading,
  required final String meaning,
  final int? reference,
}) with Equatable {
  new fromJson(Map<String, dynamic> json)
    : this(
        kanji: (json['kanji'] ?? '').toString(),
        reading: (json['reading'] ?? '').toString(),
        meaning: (json['meaning'] ?? '').toString(),
        reference: json['reference'] as int?,
      );

  @override
  List<Object?> get props => [kanji, reading, meaning, reference];
}
