import 'package:equatable/equatable.dart';

class RadicalsData {
  const RadicalsData(this.entries);

  final List<RadicalEntry> entries;
}

class RadicalEntry with EquatableMixin {
  const RadicalEntry({
    required this.id,
    required this.strokeCount,
    required this.radicals,
    required this.names,
    required this.examples,
    required this.meaning,
  });

  RadicalEntry.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      strokeCount = json['strokeCount'] as int,
      radicals = (json['radicals'] as List).cast(),
      names = json['names'] as String,
      examples = (json['examples'] as List).cast(),
      meaning = json['meaning'] as String;

  final int id;
  final int strokeCount;
  final List<String> radicals;
  final String names;
  final List<String> examples;
  final String meaning;

  @override
  List<Object?> get props => [
    id,
    strokeCount,
    radicals,
    names,
    examples,
    meaning,
  ];
}
