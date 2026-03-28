#!/usr/bin/env -S fvm dart

import 'dart:io';

import 'package:dio/dio.dart';

const fontName = 'MaterialSymbolsRounded';
const baseName = '$fontName[FILL,GRAD,opsz,wght]';
const baseUrl =
    'https://raw.githubusercontent.com/google/material-design-icons/master/variablefont';

const codepointsFile = '$fontName.codepoints';
const fontFile = 'assets/fonts/$fontName.ttf';
const outputFile = 'lib/design_system/icons.dart';

const header = '''
import 'package:flutter/widgets.dart';

enum AppIconData {
''';

const footer = '''
  const AppIconData(this.iconData);

  final IconData iconData;

  static const fontFamily = 'Material Symbols Rounded';
}''';

Future<void> main() async {
  if (!File('pubspec.yaml').existsSync()) {
    throw Exception('Run this script from the root of the project');
  }

  final dio = Dio();
  await dio.download('$baseUrl/$baseName.codepoints', codepointsFile);
  await dio.download('$baseUrl/$baseName.ttf', fontFile);

  final lines = File(codepointsFile).readAsLinesSync();

  final libraryBuffer = StringBuffer()
    ..write(header)
    ..writeAll(lines.map(makeEnumValue), ',\n')
    ..writeln(';')
    ..writeln()
    ..writeln(footer);

  File(outputFile).writeAsStringSync(libraryBuffer.toString());
}

String makeEnumValue(String line) {
  var [name, codepoint] = line.split(' ');
  codepoint = codepoint.toUpperCase();
  if (RegExp('^([0-9]+)(.*)').firstMatch(name) case final match?) {
    final number = replaceNumber(match.group(1)!);
    final rest = match.group(2)!;
    name = switch (rest) {
      '' => number,
      _ => switch (rest.startsWith('_')) {
        true => '$number$rest',
        false => '${number}_$rest',
      },
    };
  }

  return '  ${sanitizeName(snakeToCamel(name))}(.new(0x$codepoint, fontFamily: fontFamily))';
}

String snakeToCamel(String input) => input.replaceAllMapped(
  RegExp('_([a-z0-9])'),
  (match) => match.group(1)!.toUpperCase(),
);

String sanitizeName(String name) => switch (name) {
  'class' || 'switch' || 'try' => '${name}_',
  _ => name,
};

String replaceNumber(String number) => switch (number) {
  '1' => 'one',
  '2' => 'two',
  '3' => 'three',
  '4' => 'four',
  '5' => 'five',
  '6' => 'six',
  '7' => 'seven',
  '8' => 'eight',
  '9' => 'nine',
  '10' => 'ten',
  '11' => 'eleven',
  '12' => 'twelve',
  '13' => 'thirteen',
  '14' => 'fourteen',
  '15' => 'fifteen',
  '16' => 'sixteen',
  '17' => 'seventeen',
  '18' => 'eighteen',
  '19' => 'nineteen',
  '20' => 'twenty',
  '21' => 'twentyOne',
  '22' => 'twentyTwo',
  '23' => 'twentyThree',
  '24' => 'twentyFour',
  '30' => 'thirty',
  '50' => 'fifty',
  '60' => 'sixty',
  '123' => 'oneTwoThree',
  '360' => 'threeSixty',
  _ => throw ArgumentError.value(number, 'Unknown number'),
};
