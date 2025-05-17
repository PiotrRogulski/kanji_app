import 'package:flutter/material.dart';
import 'package:kanji_app/l10n/app_l10n.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
