import 'package:flutter/material.dart';
import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/l10n/app_l10n.dart';
import 'package:kanji_app/navigation/coordinator.dart';
import 'package:provider/provider.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => .of(this);
  AppCoordinator get coordinator => read();
}

extension WidgetListX on List<Widget> {
  List<Widget> _spaced(Widget spacer) => expand((item) sync* {
    yield spacer;
    yield item;
  }).skip(1).toList();

  List<Widget> spacedSliver(AppUnit space) => _spaced(space.sliverGap);

  List<Widget> spaced(AppUnit space) => _spaced(space.gap);
}

extension GenericX<T extends Object> on T {
  R apply<R>(R Function(T) f) => f(this);
}
