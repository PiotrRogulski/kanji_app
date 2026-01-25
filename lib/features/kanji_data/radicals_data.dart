import 'package:equatable/equatable.dart';

class RadicalsData {
  const RadicalsData(this.entries);

  final List<RadicalEntry> entries;
}

class RadicalEntry with EquatableMixin {
  factory RadicalEntry({
    required int id,
    required int strokeCount,
    required List<String> radicals,
    required String names,
    required List<String> examples,
    required String meaning,
  }) {
    final (parsedNames, parsedRelated) = _parseNames(names);
    return RadicalEntry._(
      id: id,
      strokeCount: strokeCount,
      radicals: radicals,
      names: parsedNames,
      relatedRadicals: parsedRelated,
      examples: examples,
      meaning: meaning,
    );
  }

  const RadicalEntry._({
    required this.id,
    required this.strokeCount,
    required this.radicals,
    required this.names,
    required this.relatedRadicals,
    required this.examples,
    required this.meaning,
  });

  factory RadicalEntry.fromJson(Map<String, dynamic> json) => RadicalEntry(
    id: json['id'] as int,
    strokeCount: json['strokeCount'] as int,
    radicals: (json['radicals'] as List).cast(),
    names: json['names'] as String,
    examples: (json['examples'] as List).cast(),
    meaning: json['meaning'] as String,
  );

  static (String, List<RelatedRadical>) _parseNames(String rawNames) {
    final parts = rawNames.split(RegExp('[＝→]'));
    if (parts.length <= 1) {
      return (rawNames, const []);
    }

    final primaryNames = parts[0].trim();
    final related = <RelatedRadical>[];

    final radicalRegex = RegExp(r'(.+?)（(\d+)\s*画）');

    for (var i = 1; i < parts.length; i++) {
      final part = parts[i].trim();
      if (part.isEmpty) {
        continue;
      }

      final match = radicalRegex.firstMatch(part);
      if (match != null) {
        related.add(
          RelatedRadical(
            radical: match.group(1)!.trim(),
            strokeCount: int.parse(match.group(2)!),
          ),
        );
      }
    }

    return (primaryNames, related);
  }

  final int id;
  final int strokeCount;
  final List<String> radicals;
  final String names;
  final List<RelatedRadical> relatedRadicals;
  final List<String> examples;
  final String meaning;

  @override
  List<Object?> get props => [
    id,
    strokeCount,
    radicals,
    names,
    relatedRadicals,
    examples,
    meaning,
  ];
}

class RelatedRadical with EquatableMixin {
  const RelatedRadical({required this.radical, required this.strokeCount});

  final String radical;
  final int strokeCount;

  @override
  List<Object?> get props => [radical, strokeCount];
}
