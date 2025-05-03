import 'package:equatable/equatable.dart';

class KanjiData {
  const KanjiData(this.entries);

  final List<KanjiEntry> entries;
}

class KanjiEntry with EquatableMixin {
  const KanjiEntry({
    required this.id,
    required this.kanji,
    required this.strokes,
    required this.radical,
    required this.antonyms,
    required this.synonyms,
    required this.readings,
    required this.words,
  });

  KanjiEntry.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      kanji = json['kanji'] as String,
      strokes = json['strokes'] as int,
      radical = json['radical'] as String?,
      antonyms = (json['antonyms'] as List?)?.cast() ?? [],
      synonyms = (json['synonyms'] as List?)?.cast() ?? [],
      readings = Readings.fromJson(json['readings'] as Map<String, dynamic>),
      words = (json['words'] as List)
          .map((e) => Word.fromJson(e as Map<String, dynamic>))
          .toList();

  final int id;
  final String kanji;
  final int strokes;
  // FIXME: Add radicals to all kanji
  final String? radical;
  final List<String> antonyms;
  final List<String> synonyms;
  final Readings readings;
  final List<Word> words;

  @override
  List<Object?> get props => [
    id,
    kanji,
    strokes,
    radical,
    antonyms,
    synonyms,
    readings,
    words,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'kanji': kanji,
    'strokes': strokes,
    'radical': radical,
    'antonyms': antonyms,
    'synonyms': synonyms,
    'readings': readings.toJson(),
    'words': words.map((e) => e.toJson()).toList(),
  };
}

class Readings with EquatableMixin {
  const Readings({required this.onyomi, required this.kunyomi});

  Readings.fromJson(Map<String, dynamic> json)
    : onyomi = (json['onyomi'] as List?)?.cast() ?? [],
      kunyomi = (json['kunyomi'] as List?)?.cast() ?? [];

  final List<String> onyomi;
  final List<String> kunyomi;

  @override
  List<Object?> get props => [onyomi, kunyomi];

  Map<String, dynamic> toJson() => {'onyomi': onyomi, 'kunyomi': kunyomi};
}

class Word with EquatableMixin {
  const Word({
    required this.word,
    required this.reading,
    required this.meaning,
    this.related,
  });

  Word.fromJson(Map<String, dynamic> json)
    : word = json['word'] as String,
      reading = json['reading'] as String,
      meaning = json['meaning'] as String,
      related = (json['related'] as List?)
          ?.map((e) => RelatedWord.fromJson(e as Map<String, dynamic>))
          .toList();

  final String word;
  final String reading;
  final String meaning;
  final List<RelatedWord>? related;

  @override
  List<Object?> get props => [word, reading, meaning, related];

  Map<String, dynamic> toJson() => {
    'word': word,
    'reading': reading,
    'meaning': meaning,
    if (related != null) 'related': related?.map((e) => e.toJson()).toList(),
  };
}

class RelatedWord with EquatableMixin {
  const RelatedWord({required this.word, required this.meaning});

  RelatedWord.fromJson(Map<String, dynamic> json)
    : word = json['word'] as String,
      meaning = json['meaning'] as String;

  final String word;
  final String meaning;

  @override
  List<Object?> get props => [word, meaning];

  Map<String, dynamic> toJson() => {'word': word, 'meaning': meaning};
}
