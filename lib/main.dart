import 'package:flutter/material.dart';
import 'package:kanji_app/features/kanji_data/loader.dart';
import 'package:kanji_app/navigation/router.dart';
import 'package:kanji_app/theme.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final d = await loadKanji();
  print(d[20].toJson());

  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useGoRouter();

    return MaterialApp.router(routerConfig: router, theme: appTheme());
  }
}
