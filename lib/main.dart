import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/features/kanji_data/loader.dart';
import 'package:kanji_app/kanji_api.dart';
import 'package:kanji_app/l10n/app_l10n.dart';
import 'package:kanji_app/navigation/router.dart';
import 'package:kanji_app/theme.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:logging/logging.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupLogger();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == .linux) {
    databaseFactory = databaseFactoryFfi;
  }

  CachedQuery.instance.configFlutter(
    config: const .new(
      staleDuration: .new(days: 7),
      cacheDuration: .new(days: 7),
    ),
    storage: await CachedStorage.ensureInitialized(),
    observers: [const QueryLoggingObserver()],
  );

  final kanjiData = await loadKanji();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: kanjiData),
        Provider(
          create: (context) => KanjiApi(
            Dio()
              ..interceptors.add(
                PrettyDioLogger(
                  requestBody: true,
                  responseBody: false,
                  logPrint: Logger('Dio').fine,
                ),
              ),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useGoRouter();

    return MaterialApp.router(
      routerConfig: router,
      theme: appTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

void _setupLogger() {
  if (kDebugMode) {
    Logger.root.level = .ALL;
  } else {
    Logger.root.level = .INFO;
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
