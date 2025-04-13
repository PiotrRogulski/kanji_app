#!/usr/bin/env -S fvm dart

import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

const codepointFile = 'MaterialSymbolsRounded.codepoints';
const outputFile = 'lib/design_system/icons.dart';

void main() {
  if (!File('pubspec.yaml').existsSync()) {
    throw Exception('Run this script from the root of the project');
  }

  if (!File(codepointFile).existsSync()) {
    throw Exception('$codepointFile not found in current directory');
  }

  final output = File(outputFile);
  if (output.existsSync()) {
    output.deleteSync();
  }

  final lines = File(codepointFile).readAsLinesSync();

  final iconDataLibrary = Library((l) {
    l.body.add(
      Enum((e) {
        e
          ..name = 'AppIconData'
          ..implements.add(refer('IconData', 'package:flutter/widgets.dart'))
          ..annotations.add(
            refer('staticIconProvider', 'package:flutter/widgets.dart'),
          )
          ..values.addAll([
            for (final (:name, :codepoint) in lines.map(parseLine))
              EnumValue((ev) {
                ev
                  ..name = name
                  ..arguments.add(CodeExpression(Code('0x$codepoint')));
              }),
          ])
          ..constructors.add(
            Constructor((c) {
              c
                ..constant = true
                ..requiredParameters.add(
                  Parameter((p) {
                    p
                      ..toThis = true
                      ..name = 'codePoint';
                  }),
                );
            }),
          )
          ..fields.addAll([
            Field((f) {
              f
                ..name = 'codePoint'
                ..type = refer('int')
                ..modifier = FieldModifier.final$
                ..annotations.add(refer('override'));
            }),
            Field((f) {
              f
                ..name = 'fontFamily'
                ..modifier = FieldModifier.final$
                ..annotations.add(refer('override'))
                ..assignment = literalString('Material Symbols Rounded').code;
            }),
            Field((f) {
              f
                ..name = 'fontPackage'
                ..type = refer('String?')
                ..modifier = FieldModifier.final$
                ..annotations.add(refer('override'))
                ..assignment = literalNull.code;
            }),
            Field((f) {
              f
                ..name = 'fontFamilyFallback'
                ..type = refer('List<String>?')
                ..modifier = FieldModifier.final$
                ..annotations.add(refer('override'))
                ..assignment = literalNull.code;
            }),
            Field((f) {
              f
                ..name = 'matchTextDirection'
                ..modifier = FieldModifier.final$
                ..annotations.add(refer('override'))
                ..assignment = literalFalse.code;
            }),
          ]);
      }),
    );
  });

  output.writeAsStringSync(
    DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(
      iconDataLibrary.accept(DartEmitter(allocator: Allocator())).toString(),
    ),
  );
}

({String name, String codepoint}) parseLine(String line) {
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

  return (name: sanitizeName(snakeToCamel(name)), codepoint: codepoint);
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
