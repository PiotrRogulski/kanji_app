// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get common_back => 'Wróć';

  @override
  String get common_scrollToTop => 'Przewiń do góry';

  @override
  String get common_search => 'Szukaj';

  @override
  String get flashcards_emptyDeck => 'Brak kart w wybranym zakresie';

  @override
  String get flashcards_end => 'Koniec!';

  @override
  String get flashcards_mode => 'Tryb';

  @override
  String get flashcards_modeKanji => 'Znaki';

  @override
  String get flashcards_modeMixed => 'Wszystko';

  @override
  String get flashcards_modeWords => 'Słowa';

  @override
  String get flashcards_selectRange => 'Wybierz zakres';

  @override
  String get flashcards_start => 'Rozpocznij';

  @override
  String get flashcards_title => 'Fiszki';

  @override
  String get kanjiDetails_strokeOrderNotAvailable =>
      'Kolejność pisania niedostępna';

  @override
  String get kanjiList_search => 'Szukaj znaków';

  @override
  String get kanjiList_title => 'Znaki';

  @override
  String get kanjiSets_title => 'Zestawy';

  @override
  String get kanji_additionalWords => 'Dodatkowe';

  @override
  String get kanji_antonyms => 'Antonimy';

  @override
  String get kanji_radical => 'Pierwiastek';

  @override
  String get kanji_readings => 'Czytania';

  @override
  String get kanji_strokeOrder => 'Kolejność pisania';

  @override
  String get kanji_synonyms => 'Synonimy';

  @override
  String get kanji_wordsRequiredLater => 'Na później';

  @override
  String get kanji_wordsRequiredNow => 'Słowa';

  @override
  String get radicals_exampleKanji => 'Na przykład w';

  @override
  String radicals_strokeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kresek',
      few: '$count kreski',
      one: '1 kreska',
    );
    return '$_temp0';
  }

  @override
  String get radicals_title => 'Pierwiastki';
}
