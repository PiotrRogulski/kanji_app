import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// No description provided for @common_search.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj'**
  String get common_search;

  /// No description provided for @common_scrollToTop.
  ///
  /// In pl, this message translates to:
  /// **'Przewiń do góry'**
  String get common_scrollToTop;

  /// No description provided for @kanjiDetails_strokeOrderNotAvailable.
  ///
  /// In pl, this message translates to:
  /// **'Kolejność pisania niedostępna'**
  String get kanjiDetails_strokeOrderNotAvailable;

  /// No description provided for @kanjiList_search.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj znaków'**
  String get kanjiList_search;

  /// No description provided for @kanjiList_title.
  ///
  /// In pl, this message translates to:
  /// **'Znaki'**
  String get kanjiList_title;

  /// No description provided for @kanjiSets_title.
  ///
  /// In pl, this message translates to:
  /// **'Zestawy'**
  String get kanjiSets_title;

  /// No description provided for @kanji_antonyms.
  ///
  /// In pl, this message translates to:
  /// **'Antonimy'**
  String get kanji_antonyms;

  /// No description provided for @kanji_radical.
  ///
  /// In pl, this message translates to:
  /// **'Pierwiastek'**
  String get kanji_radical;

  /// No description provided for @kanji_readings.
  ///
  /// In pl, this message translates to:
  /// **'Czytania'**
  String get kanji_readings;

  /// No description provided for @kanji_strokeOrder.
  ///
  /// In pl, this message translates to:
  /// **'Kolejność pisania'**
  String get kanji_strokeOrder;

  /// No description provided for @kanji_synonyms.
  ///
  /// In pl, this message translates to:
  /// **'Synonimy'**
  String get kanji_synonyms;

  /// No description provided for @radicals_exampleKanji.
  ///
  /// In pl, this message translates to:
  /// **'Na przykład w'**
  String get radicals_exampleKanji;

  /// No description provided for @radicals_title.
  ///
  /// In pl, this message translates to:
  /// **'Pierwiastki'**
  String get radicals_title;

  /// No description provided for @radicals_strokeCount.
  ///
  /// In pl, this message translates to:
  /// **'{count, plural, one {1 kreska} few {{count} kreski} other {{count} kresek}}'**
  String radicals_strokeCount(num count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
