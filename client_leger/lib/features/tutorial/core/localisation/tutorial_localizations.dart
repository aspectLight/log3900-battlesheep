import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'tutorial_localizations_en.dart';
import 'tutorial_localizations_fr.dart';

abstract class TutorialLocalizations {
  TutorialLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale);

  final String localeName;

  static TutorialLocalizations? of(BuildContext context) {
    return Localizations.of<TutorialLocalizations>(
      context,
      TutorialLocalizations,
    );
  }

  static const LocalizationsDelegate<TutorialLocalizations> delegate =
      _TutorialLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  String get tutorialTitle;

  String get quit;

  String get finish;

  String get next;

  String get previous;

  String get profileTitle;

  String get profileDesc;

  String get friendsTitle;

  String get friendsDesc;

  String get chatTitle;

  String get chatDesc;

  String get shopTitle;

  String get shopDesc;

  String get gameModesTitle;

  String get gameModesDesc;

  String get createGameTitle;

  String get createGameDesc;

  String get joinGameTitle;

  String get joinGameDesc;
}

class _TutorialLocalizationsDelegate
    extends LocalizationsDelegate<TutorialLocalizations> {
  const _TutorialLocalizationsDelegate();

  @override
  Future<TutorialLocalizations> load(Locale locale) {
    return SynchronousFuture<TutorialLocalizations>(
      lookupTutorialLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_TutorialLocalizationsDelegate old) => false;
}

TutorialLocalizations lookupTutorialLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return TutorialLocalizationsEn();
    case 'fr':
      return TutorialLocalizationsFr();
  }

  throw FlutterError(
    'TutorialLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
