import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'select_game_session_localizations_en.dart';
import 'select_game_session_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SelectGameSessionLocalizations
/// returned by `SelectGameSessionLocalizations.of(context)`.
///
/// Applications need to include `SelectGameSessionLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/select_game_session_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SelectGameSessionLocalizations.localizationsDelegates,
///   supportedLocales: SelectGameSessionLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the SelectGameSessionLocalizations.supportedLocales
/// property.
abstract class SelectGameSessionLocalizations {
  SelectGameSessionLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SelectGameSessionLocalizations? of(BuildContext context) {
    return Localizations.of<SelectGameSessionLocalizations>(
      context,
      SelectGameSessionLocalizations,
    );
  }

  static const LocalizationsDelegate<SelectGameSessionLocalizations> delegate =
      _SelectGameSessionLocalizationsDelegate();

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

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainMenu;

  /// No description provided for @createGame.
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @selectedGameHiddenOrDeleted.
  ///
  /// In en, this message translates to:
  /// **'The selected game is hidden or deleted.'**
  String get selectedGameHiddenOrDeleted;

  /// No description provided for @createGamePreviewHeader.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get createGamePreviewHeader;

  /// No description provided for @createGameNameHeader.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get createGameNameHeader;

  /// No description provided for @createGameSizeHeader.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get createGameSizeHeader;

  /// No description provided for @createGameModeHeader.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get createGameModeHeader;

  /// No description provided for @createGameLastModifiedHeader.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get createGameLastModifiedHeader;

  /// No description provided for @createGameModeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get createGameModeClassic;

  /// No description provided for @createGameModeCtf.
  ///
  /// In en, this message translates to:
  /// **'Capture the flag'**
  String get createGameModeCtf;

  String get noGames;
}

class _SelectGameSessionLocalizationsDelegate
    extends LocalizationsDelegate<SelectGameSessionLocalizations> {
  const _SelectGameSessionLocalizationsDelegate();

  @override
  Future<SelectGameSessionLocalizations> load(Locale locale) {
    return SynchronousFuture<SelectGameSessionLocalizations>(
      lookupSelectGameSessionLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SelectGameSessionLocalizationsDelegate old) => false;
}

SelectGameSessionLocalizations lookupSelectGameSessionLocalizations(
  Locale locale,
) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SelectGameSessionLocalizationsEn();
    case 'fr':
      return SelectGameSessionLocalizationsFr();
  }

  throw FlutterError(
    'SelectGameSessionLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
