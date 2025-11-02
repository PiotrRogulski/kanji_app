#!/usr/bin/env -S fvm dart

import 'dart:convert';
import 'dart:io' as io;

import 'package:characters/characters.dart';
import 'package:excel/excel.dart';
import 'package:file/local.dart';

typedef Word = ({String kanji, String? reading});

const fs = LocalFileSystem();

String serializeEntry(Map<String, dynamic> entry) =>
    '${const JsonEncoder.withIndent('  ').convert(entry)}\n';

Never printHelp() {
  io.stderr.write('''
Usage:
  extract_excel.dart [words|radicals] <path_to_excel_file>
''');
  io.exit(1);
}

Future<void> main(List<String> args) async {
  if (args.length != 2) {
    printHelp();
  }

  final [command, filePath] = args;

  final file = fs.file(filePath);
  final excel = Excel.decodeBytes(file.readAsBytesSync());

  switch (command) {
    case 'words':
      await extractWords(excel);
    case 'radicals':
      await extractRadicals(excel);
    default:
      printHelp();
  }
}

Future<void> extractWords(Excel excel) async {
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

Future<void> extractRadicals(Excel excel) async {
  final sheet = excel['Elementy znaków'];

  final outputDir = fs.directory('radicals')..createSync(recursive: true);

  final startID = int.parse(sheet.cell(.indexByString('A12')).value.toString());

  for (final (i, row) in sheet.rows.skip(11).indexed) {
    if (row.first?.value == null) {
      continue;
    }

    final id = startID + i;
    final [_, strokeCount, radicals, names, examples, meaning] = row;

    outputDir
        .childFile('$id.json')
        .writeAsStringSync(
          serializeEntry({
            'id': id,
            'strokeCount': parseStrokeCount(strokeCount!.value!.toString()),
            'radicals': radicals!.value!.toString().split('／'),
            // TODO: split & parse names
            'names': names!.value!.toString(),
            'examples': examples!.value!.toString().split('、'),
            'meaning': meaning!.value!.toString(),
          }),
        );
  }
}

int parseStrokeCount(String value) {
  final trimmed = value.replaceFirst('画', '');
  final normalized = trimmed.characters
      .map(
        (c) => switch (c) {
          '０' => '0',
          '１' => '1',
          '２' => '2',
          '３' => '3',
          '４' => '4',
          '５' => '5',
          '６' => '6',
          '７' => '7',
          '８' => '8',
          '９' => '9',
          _ => c,
        },
      )
      .join();

  return .parse(normalized);
}
