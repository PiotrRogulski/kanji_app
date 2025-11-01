#!/usr/bin/env -S fvm dart

import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:file/local.dart';

typedef Word = ({String kanji, String? reading});

const fs = LocalFileSystem();

String serializeEntry(Map<String, dynamic> entry) =>
    '${const JsonEncoder.withIndent('  ').convert(entry)}\n';

Future<void> main(List<String> args) async {
  final filePath =
      args.elementAtOrNull(0) ?? (throw Exception('Provide a file path'));
  final file = fs.file(filePath);
  final excel = Excel.decodeBytes(file.readAsBytesSync());
  final sheet = excel['znaki 461-1535'];

  final outputDir = fs.directory('entries')..createSync(recursive: true);

  final startID = int.parse(sheet.cell(.indexByString('A2')).value.toString());

  for (final (i, row) in sheet.rows.skip(1).indexed) {
    final id = startID + i;
    final kanji = row[1]!.value!.toString();
    final readings = row[2]!.value!.toString().split('、');

    final wordsRequiredNow = <Word>[];
    final wordsRequiredLater = <({Word word, int reference})>[];
    final additionalWords = <Word>[];

    for (final word in row.skip(3).map((e) => e?.value?.toString()).nonNulls) {
      final parts = word.split('　');
      final kanji = parts[0];
      final reading = parts.elementAtOrNull(1);
      final reference = parts.elementAtOrNull(2);

      if (word.startsWith('＊')) {
        wordsRequiredLater.add((
          word: (kanji: kanji.substring(1), reading: reading),
          reference: .tryParse(reference ?? '') ?? 0,
        ));
      } else if (word.startsWith('ciekawostka: ')) {
        additionalWords.add((
          kanji: kanji.substring('ciekawostka: '.length),
          reading: reading,
        ));
      } else {
        wordsRequiredNow.add((kanji: kanji, reading: reading));
      }
    }

    outputDir
        .childFile('$id.json')
        .writeAsStringSync(
          serializeEntry({
            'id': id,
            'kanji': kanji,
            'readings': readings,
            'wordsRequiredNow': [
              for (final e in wordsRequiredNow)
                {'kanji': e.kanji, 'reading': e.reading},
            ],
            'wordsRequiredLater': [
              for (final e in wordsRequiredLater)
                {
                  'kanji': e.word.kanji,
                  'reading': e.word.reading,
                  'reference': e.reference,
                },
            ],
            'additionalWords': [
              for (final e in additionalWords)
                {'kanji': e.kanji, 'reading': e.reading},
            ],
          }),
        );
  }
}
