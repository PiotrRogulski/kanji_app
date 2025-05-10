import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/features/kanji_data/loader.dart';
import 'package:kanji_app/navigation/router.dart';
import 'package:kanji_app/theme.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupLogger();

  final kanjiData = await loadKanji();

  runApp(Provider.value(value: kanjiData, child: const MainApp()));
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useGoRouter();

    return MaterialApp.router(routerConfig: router, theme: appTheme());
  }
}

void _setupLogger() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.INFO;
  }

  Logger.root.onRecord.listen((record) {
    final message = StringBuffer(
      '[${record.loggerName}] ${record.level.name}: ${record.message}',
    );
    if (record.error case final error?) {
      message.write('\nError: $error');
    }
    if (record.stackTrace case final stackTrace?) {
      message.write('\nStackTrace: $stackTrace');
    }

    debugPrint(message.toString());
  });
}
