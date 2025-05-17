#!/usr/bin/env -S fvm dart

import 'dart:io';

import 'package:arb_utils/arb_utils.dart';

Future<int> main() async {
  final arbs = Directory('lib/l10n/arb').listSync().whereType<File>();
  for (final arb in arbs) {
    final content = arb.readAsStringSync();
    final sorted = sortARB(content);
    arb.writeAsStringSync(sorted);
    if (!sorted.endsWith('\n')) {
      arb.writeAsStringSync('\n', mode: FileMode.append);
    }
  }

  final process = await Process.start('fvm', ['flutter', 'gen-l10n']);
  await (
    stdout.addStream(process.stdout),
    stderr.addStream(process.stderr),
  ).wait;

  return process.exitCode;
}
