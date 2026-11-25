import 'package:kanji_app/l10n/app_l10n.dart';
import 'package:material_ui/material_ui.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension GenericX<T extends Object> on T {
  R apply<R>(R Function(T) f) => f(this);
}
