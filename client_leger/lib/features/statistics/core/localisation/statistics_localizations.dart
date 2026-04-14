import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'statistics_localizations_en.dart';
import 'statistics_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StatisticsLocalizations
/// returned by `StatisticsLocalizations.of(context)`.
///
/// Applications need to include `StatisticsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/statistics_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StatisticsLocalizations.localizationsDelegates,
///   supportedLocales: StatisticsLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the StatisticsLocalizations.supportedLocales
/// property.
abstract class StatisticsLocalizations {
  StatisticsLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StatisticsLocalizations? of(BuildContext context) {
    return Localizations.of<StatisticsLocalizations>(
      context,
      StatisticsLocalizations,
    );
  }

  static const LocalizationsDelegate<StatisticsLocalizations> delegate =
      _StatisticsLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @statisticsReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get statisticsReturnHome;

  /// No description provided for @statisticsPlayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get statisticsPlayersTitle;

  /// No description provided for @statisticsPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get statisticsPlayerName;

  /// No description provided for @statisticsCombats.
  ///
  /// In en, this message translates to:
  /// **'Number of combats'**
  String get statisticsCombats;

  /// No description provided for @statisticsEvasions.
  ///
  /// In en, this message translates to:
  /// **'Number of evasions'**
  String get statisticsEvasions;

  /// No description provided for @statisticsVictories.
  ///
  /// In en, this message translates to:
  /// **'Number of victories'**
  String get statisticsVictories;

  /// No description provided for @statisticsDefeats.
  ///
  /// In en, this message translates to:
  /// **'Number of defeats'**
  String get statisticsDefeats;

  /// No description provided for @statisticsHealthLost.
  ///
  /// In en, this message translates to:
  /// **'Health points lost'**
  String get statisticsHealthLost;

  /// No description provided for @statisticsDamage.
  ///
  /// In en, this message translates to:
  /// **'Health points dealt'**
  String get statisticsDamage;

  /// No description provided for @statisticsItemsCollected.
  ///
  /// In en, this message translates to:
  /// **'Number of different items collected'**
  String get statisticsItemsCollected;

  /// No description provided for @statisticsTilesVisited.
  ///
  /// In en, this message translates to:
  /// **'Percentage of terrain tiles visited'**
  String get statisticsTilesVisited;

  /// No description provided for @statisticsGlobalTitle.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get statisticsGlobalTitle;

  /// No description provided for @statisticsRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get statisticsRewardsTitle;

  /// No description provided for @statisticsDuration.
  ///
  /// In en, this message translates to:
  /// **'Game duration'**
  String get statisticsDuration;

  /// No description provided for @statisticsTurns.
  ///
  /// In en, this message translates to:
  /// **'Number of game turns'**
  String get statisticsTurns;

  /// No description provided for @statisticsTilesExplored.
  ///
  /// In en, this message translates to:
  /// **'Percentage of terrain tiles visited by at least one player'**
  String get statisticsTilesExplored;

  /// No description provided for @statisticsDoorsToggled.
  ///
  /// In en, this message translates to:
  /// **'Percentage of doors toggled at least once'**
  String get statisticsDoorsToggled;

  /// No description provided for @statisticsFlags.
  ///
  /// In en, this message translates to:
  /// **'Number of different players who held the flag'**
  String get statisticsFlags;
}

class _StatisticsLocalizationsDelegate
    extends LocalizationsDelegate<StatisticsLocalizations> {
  const _StatisticsLocalizationsDelegate();

  @override
  Future<StatisticsLocalizations> load(Locale locale) {
    return SynchronousFuture<StatisticsLocalizations>(
      lookupStatisticsLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_StatisticsLocalizationsDelegate old) => false;
}

StatisticsLocalizations lookupStatisticsLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StatisticsLocalizationsEn();
    case 'fr':
      return StatisticsLocalizationsFr();
  }

  throw FlutterError(
    'StatisticsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
