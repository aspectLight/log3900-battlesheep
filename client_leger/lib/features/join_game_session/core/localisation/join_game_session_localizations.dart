import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'join_game_session_localizations_en.dart';
import 'join_game_session_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of JoinGameSessionLocalizations
/// returned by `JoinGameSessionLocalizations.of(context)`.
///
/// Applications need to include `JoinGameSessionLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/join_game_session_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: JoinGameSessionLocalizations.localizationsDelegates,
///   supportedLocales: JoinGameSessionLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the JoinGameSessionLocalizations.supportedLocales
/// property.
abstract class JoinGameSessionLocalizations {
  JoinGameSessionLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static JoinGameSessionLocalizations? of(BuildContext context) {
    return Localizations.of<JoinGameSessionLocalizations>(
      context,
      JoinGameSessionLocalizations,
    );
  }

  static const LocalizationsDelegate<JoinGameSessionLocalizations> delegate =
      _JoinGameSessionLocalizationsDelegate();

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
  /// **'Main menu'**
  String get mainMenu;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @joinGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a game'**
  String get joinGameTitle;

  /// No description provided for @joinGameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit game code'**
  String get joinGameSubtitle;

  /// No description provided for @joinGameDescription.
  ///
  /// In en, this message translates to:
  /// **'You can find this code in the waiting room of the game'**
  String get joinGameDescription;

  /// No description provided for @joinGameButton.
  ///
  /// In en, this message translates to:
  /// **'Access waiting room'**
  String get joinGameButton;

  /// No description provided for @joinGameFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to join game'**
  String get joinGameFailed;

  /// No description provided for @joinGameNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No available game'**
  String get joinGameNoRooms;

  /// No description provided for @joinGameRoomListPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get joinGameRoomListPreview;

  /// No description provided for @joinGameRoomListPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get joinGameRoomListPlayers;

  /// No description provided for @joinGameRoomListSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get joinGameRoomListSize;

  /// No description provided for @joinGameRoomListStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get joinGameRoomListStatus;

  /// No description provided for @joinGameRoomListMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get joinGameRoomListMode;

  /// No description provided for @joinGameRoomListAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get joinGameRoomListAccessibility;

  /// No description provided for @joinGameRoomListCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get joinGameRoomListCode;

  /// No description provided for @joinGameRoomListPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get joinGameRoomListPrice;

  /// No description provided for @joinGameStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get joinGameStatusWaiting;

  /// No description provided for @joinGameStatusPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get joinGameStatusPlaying;

  /// No description provided for @joinGameModeDropIn.
  ///
  /// In en, this message translates to:
  /// **'Drop-in'**
  String get joinGameModeDropIn;

  /// No description provided for @joinGameAccessibilityOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get joinGameAccessibilityOpen;

  /// No description provided for @joinGameAccessibilityFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get joinGameAccessibilityFull;

  /// No description provided for @joinGamePriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get joinGamePriceFree;

  /// No description provided for @waitingRoomRoomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Game not found'**
  String get waitingRoomRoomNotFound;

  /// No description provided for @waitingRoomRoomLocked.
  ///
  /// In en, this message translates to:
  /// **'Game is locked'**
  String get waitingRoomRoomLocked;

  /// No description provided for @joinGameMaxPlayerLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum player limit reached'**
  String get joinGameMaxPlayerLimitReached;

  /// No description provided for @joinGameInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance to join this game'**
  String get joinGameInsufficientBalance;
}

class _JoinGameSessionLocalizationsDelegate
    extends LocalizationsDelegate<JoinGameSessionLocalizations> {
  const _JoinGameSessionLocalizationsDelegate();

  @override
  Future<JoinGameSessionLocalizations> load(Locale locale) {
    return SynchronousFuture<JoinGameSessionLocalizations>(
      lookupJoinGameSessionLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_JoinGameSessionLocalizationsDelegate old) => false;
}

JoinGameSessionLocalizations lookupJoinGameSessionLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return JoinGameSessionLocalizationsEn();
    case 'fr':
      return JoinGameSessionLocalizationsFr();
  }

  throw FlutterError(
    'JoinGameSessionLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
