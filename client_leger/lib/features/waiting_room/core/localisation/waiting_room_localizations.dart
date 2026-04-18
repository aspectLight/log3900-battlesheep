import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'waiting_room_localizations_en.dart';
import 'waiting_room_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of WaitingRoomLocalizations
/// returned by `WaitingRoomLocalizations.of(context)`.
///
/// Applications need to include `WaitingRoomLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/waiting_room_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: WaitingRoomLocalizations.localizationsDelegates,
///   supportedLocales: WaitingRoomLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the WaitingRoomLocalizations.supportedLocales
/// property.
abstract class WaitingRoomLocalizations {
  WaitingRoomLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static WaitingRoomLocalizations? of(BuildContext context) {
    return Localizations.of<WaitingRoomLocalizations>(
      context,
      WaitingRoomLocalizations,
    );
  }

  static const LocalizationsDelegate<WaitingRoomLocalizations> delegate =
      _WaitingRoomLocalizationsDelegate();

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Leave game'**
  String get back;

  /// No description provided for @waitingRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting room'**
  String get waitingRoomTitle;

  /// No description provided for @waitingRoom.
  ///
  /// In en, this message translates to:
  /// **'WAITING ROOM'**
  String get waitingRoom;

  /// No description provided for @gameCode.
  ///
  /// In en, this message translates to:
  /// **'Game Code :'**
  String get gameCode;

  /// No description provided for @waitingRoomGameCode.
  ///
  /// In en, this message translates to:
  /// **'Code of the game :'**
  String get waitingRoomGameCode;

  /// No description provided for @waitingRoomWaitingForPlayers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for players...'**
  String get waitingRoomWaitingForPlayers;

  /// No description provided for @waitingForPlayers.
  ///
  /// In en, this message translates to:
  /// **'Waiting For Players...'**
  String get waitingForPlayers;

  /// No description provided for @waitingRoomWaitingForHost.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the game host...'**
  String get waitingRoomWaitingForHost;

  /// No description provided for @waitingForHost.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the game host...'**
  String get waitingForHost;

  /// No description provided for @waitingRoomUnlockRoom.
  ///
  /// In en, this message translates to:
  /// **'Unlock room'**
  String get waitingRoomUnlockRoom;

  /// No description provided for @unlockRoom.
  ///
  /// In en, this message translates to:
  /// **'Unlock room'**
  String get unlockRoom;

  /// No description provided for @waitingRoomLockRoom.
  ///
  /// In en, this message translates to:
  /// **'Lock room'**
  String get waitingRoomLockRoom;

  /// No description provided for @lockRoom.
  ///
  /// In en, this message translates to:
  /// **'Lock room'**
  String get lockRoom;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get startGame;

  /// No description provided for @waitingRoomAddVirtualPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add virtual player'**
  String get waitingRoomAddVirtualPlayer;

  /// No description provided for @waitingRoomDropInDropOut.
  ///
  /// In en, this message translates to:
  /// **'Drop-in/Drop-out'**
  String get waitingRoomDropInDropOut;

  /// No description provided for @addVirtualPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add virtual player'**
  String get addVirtualPlayer;

  /// No description provided for @selectVirtualProfile.
  ///
  /// In en, this message translates to:
  /// **'Select the virtual player\'s profile:'**
  String get selectVirtualProfile;

  /// No description provided for @waitingRoomVirtualPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Virtual player name'**
  String get waitingRoomVirtualPlayerName;

  /// No description provided for @waitingRoomVirtualPlayerCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get waitingRoomVirtualPlayerCharacter;

  /// No description provided for @waitingRoomVirtualPlayerType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get waitingRoomVirtualPlayerType;

  /// No description provided for @aggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get aggressive;

  /// No description provided for @defensive.
  ///
  /// In en, this message translates to:
  /// **'Defensive'**
  String get defensive;

  /// No description provided for @waitingRoomAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get waitingRoomAddButton;

  /// No description provided for @confirmLeaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to leave the game?'**
  String get confirmLeaveRoom;

  /// No description provided for @confirmLockRoom.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to lock the room?'**
  String get confirmLockRoom;

  /// No description provided for @confirmUnlockRoom.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to unlock the room?'**
  String get confirmUnlockRoom;

  /// No description provided for @confirmKickPlayer.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to kick this player?'**
  String get confirmKickPlayer;

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

  /// No description provided for @waitingRoomCharacterAlreadyReserved.
  ///
  /// In en, this message translates to:
  /// **'Character already taken'**
  String get waitingRoomCharacterAlreadyReserved;

  /// No description provided for @waitingRoomPlayerAlreadyInRoom.
  ///
  /// In en, this message translates to:
  /// **'This player is already in the room'**
  String get waitingRoomPlayerAlreadyInRoom;

  /// No description provided for @waitingRoomPlayerKicked.
  ///
  /// In en, this message translates to:
  /// **'You have been kicked'**
  String get waitingRoomPlayerKicked;

  /// No description provided for @waitingRoomMaxPlayerLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum player limit reached'**
  String get waitingRoomMaxPlayerLimitReached;

  /// No description provided for @waitingRoomStartGameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start game'**
  String get waitingRoomStartGameFailed;

  /// No description provided for @waitingRoomStatHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get waitingRoomStatHealth;

  /// No description provided for @waitingRoomStatSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get waitingRoomStatSpeed;

  /// No description provided for @waitingRoomStatAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get waitingRoomStatAttack;

  /// No description provided for @waitingRoomStatDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get waitingRoomStatDefense;

  /// No description provided for @waitingRoomBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance:'**
  String get waitingRoomBalanceLabel;

  /// No description provided for @waitingRoomEntryFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Entry fee:'**
  String get waitingRoomEntryFeeLabel;

  /// No description provided for @waitingRoomFriendsOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Friends only:'**
  String get waitingRoomFriendsOnlyLabel;

  /// No description provided for @gameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Game not found'**
  String get gameNotFound;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @waitingRoomWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Bienvenue dans la salle d\'attente, partagez le code de la partie avec vos amis !'**
  String get waitingRoomWelcomeMessage;

  /// No description provided for @waitingRoomJoinQrLabel.
  ///
  /// In en, this message translates to:
  /// **'QR code with the 4-digit game code'**
  String get waitingRoomJoinQrLabel;
}

class _WaitingRoomLocalizationsDelegate
    extends LocalizationsDelegate<WaitingRoomLocalizations> {
  const _WaitingRoomLocalizationsDelegate();

  @override
  Future<WaitingRoomLocalizations> load(Locale locale) {
    return SynchronousFuture<WaitingRoomLocalizations>(
      lookupWaitingRoomLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_WaitingRoomLocalizationsDelegate old) => false;
}

WaitingRoomLocalizations lookupWaitingRoomLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return WaitingRoomLocalizationsEn();
    case 'fr':
      return WaitingRoomLocalizationsFr();
  }

  throw FlutterError(
    'WaitingRoomLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
