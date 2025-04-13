import 'package:flutter/material.dart';
import 'package:kanji_app/navigation/router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useGoRouter();

    return MaterialApp.router(routerConfig: router);
  }
}
