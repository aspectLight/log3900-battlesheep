import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'game_session_localizations_en.dart';
import 'game_session_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GameSessionLocalizations
/// returned by `GameSessionLocalizations.of(context)`.
///
/// Applications need to include `GameSessionLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/game_session_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GameSessionLocalizations.localizationsDelegates,
///   supportedLocales: GameSessionLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the GameSessionLocalizations.supportedLocales
/// property.
abstract class GameSessionLocalizations {
  GameSessionLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GameSessionLocalizations? of(BuildContext context) {
    return Localizations.of<GameSessionLocalizations>(
      context,
      GameSessionLocalizations,
    );
  }

  static const LocalizationsDelegate<GameSessionLocalizations> delegate =
      _GameSessionLocalizationsDelegate();

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

  /// No description provided for @gameContentSoon.
  ///
  /// In en, this message translates to:
  /// **'Game content coming soon...'**
  String get gameContentSoon;

  /// No description provided for @gameInventoryFullDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory full'**
  String get gameInventoryFullDiscardTitle;

  /// No description provided for @gameTrapTitle.
  ///
  /// In en, this message translates to:
  /// **'You are on a trap!'**
  String get gameTrapTitle;

  /// No description provided for @gameTrapDescriptionCanAvoid.
  ///
  /// In en, this message translates to:
  /// **'You can avoid the trap or try to cross it.'**
  String get gameTrapDescriptionCanAvoid;

  /// No description provided for @gameTrapDescriptionMustTraverse.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough movement points to avoid the trap. You must cross it.'**
  String get gameTrapDescriptionMustTraverse;

  /// No description provided for @gameTrapAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get gameTrapAvoid;

  /// No description provided for @gameTrapTraverse.
  ///
  /// In en, this message translates to:
  /// **'Cross'**
  String get gameTrapTraverse;

  /// No description provided for @gamePlayersListPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing...'**
  String get gamePlayersListPlaying;

  /// No description provided for @gamePlayersListVirtual.
  ///
  /// In en, this message translates to:
  /// **'Virtual'**
  String get gamePlayersListVirtual;

  /// No description provided for @gameTimerCurrentTurn.
  ///
  /// In en, this message translates to:
  /// **'Current turn: {seconds}'**
  String gameTimerCurrentTurn(int seconds);

  /// No description provided for @gameDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug mode activated'**
  String get gameDebugMode;

  /// No description provided for @gameActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get gameActionCancel;

  /// No description provided for @gameActionAct.
  ///
  /// In en, this message translates to:
  /// **'Act'**
  String get gameActionAct;

  /// No description provided for @gameActionForwardTurn.
  ///
  /// In en, this message translates to:
  /// **'End turn'**
  String get gameActionForwardTurn;

  /// No description provided for @gameCellDetailCost.
  ///
  /// In en, this message translates to:
  /// **'COST'**
  String get gameCellDetailCost;

  /// No description provided for @gameCellDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get gameCellDetailDescription;

  /// No description provided for @gameCellDetailYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get gameCellDetailYou;

  /// No description provided for @combatYourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn! You have: {countdown} seconds left'**
  String combatYourTurn(int countdown);

  /// No description provided for @combatYourTurnIn.
  ///
  /// In en, this message translates to:
  /// **'Your turn in: {countdown} seconds'**
  String combatYourTurnIn(int countdown);

  /// No description provided for @combatFlightAttemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} escape attempts remaining'**
  String combatFlightAttemptsLeft(int count);

  /// No description provided for @combatYourDefense.
  ///
  /// In en, this message translates to:
  /// **'YOUR DEFENSE'**
  String get combatYourDefense;

  /// No description provided for @combatYourAttack.
  ///
  /// In en, this message translates to:
  /// **'YOUR ATTACK'**
  String get combatYourAttack;

  /// No description provided for @combatEnemyAttack.
  ///
  /// In en, this message translates to:
  /// **'ENEMY ATTACK'**
  String get combatEnemyAttack;

  /// No description provided for @combatEnemyDefense.
  ///
  /// In en, this message translates to:
  /// **'ENEMY DEFENSE'**
  String get combatEnemyDefense;

  /// No description provided for @combatFlee.
  ///
  /// In en, this message translates to:
  /// **'Flee!'**
  String get combatFlee;

  /// No description provided for @combatAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get combatAttack;

  /// No description provided for @combatMissTitle.
  ///
  /// In en, this message translates to:
  /// **'Missed!'**
  String get combatMissTitle;

  /// No description provided for @combatEvadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Dodged!'**
  String get combatEvadedTitle;

  /// No description provided for @combatFlightAttemptTitle.
  ///
  /// In en, this message translates to:
  /// **'Escape attempt!'**
  String get combatFlightAttemptTitle;

  /// No description provided for @combatFlightAttemptSuccess.
  ///
  /// In en, this message translates to:
  /// **'You managed to flee!'**
  String get combatFlightAttemptSuccess;

  /// No description provided for @combatFlightAttemptFailure.
  ///
  /// In en, this message translates to:
  /// **'You failed to flee!'**
  String get combatFlightAttemptFailure;

  /// No description provided for @combatBarbedWireTitle.
  ///
  /// In en, this message translates to:
  /// **'Barbed Wire'**
  String get combatBarbedWireTitle;

  /// No description provided for @combatBarbedWireBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Fleeing is impossible for the opponent, only if you initiated the combat'**
  String get combatBarbedWireBlockedMessage;

  /// No description provided for @combatNotificationVictory.
  ///
  /// In en, this message translates to:
  /// **'Victory!'**
  String get combatNotificationVictory;

  /// No description provided for @combatNotificationVictoryMessage.
  ///
  /// In en, this message translates to:
  /// **'You won the fight!'**
  String get combatNotificationVictoryMessage;

  /// No description provided for @combatNotificationDefeat.
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get combatNotificationDefeat;

  /// No description provided for @combatNotificationDefeatMessage.
  ///
  /// In en, this message translates to:
  /// **'{winnerName} won the fight!'**
  String combatNotificationDefeatMessage(String winnerName);

  /// No description provided for @combatNotificationFlightSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Escape successful!'**
  String get combatNotificationFlightSuccessTitle;

  /// No description provided for @combatNotificationFlightSuccess.
  ///
  /// In en, this message translates to:
  /// **'You managed to flee!'**
  String get combatNotificationFlightSuccess;

  /// No description provided for @combatNotificationEnemyFled.
  ///
  /// In en, this message translates to:
  /// **'{enemyName} managed to flee!'**
  String combatNotificationEnemyFled(String enemyName);

  /// No description provided for @combatStartedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Combat started'**
  String get combatStartedNotificationTitle;

  /// No description provided for @combatStartedNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'{attackerName} vs {defenderName}'**
  String combatStartedNotificationMessage(
    String attackerName,
    String defenderName,
  );

  /// No description provided for @combatStatAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get combatStatAttack;

  /// No description provided for @combatStatDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get combatStatDefense;

  /// No description provided for @combatStatSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get combatStatSpeed;

  /// No description provided for @combatStatHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get combatStatHealth;

  /// No description provided for @notificationVictoryCtf.
  ///
  /// In en, this message translates to:
  /// **'Victory! Your team captured the flag!'**
  String get notificationVictoryCtf;

  /// No description provided for @notificationVictoryClassic.
  ///
  /// In en, this message translates to:
  /// **'Victory! You won three combats'**
  String get notificationVictoryClassic;

  /// No description provided for @notificationDefeatCtfKnown.
  ///
  /// In en, this message translates to:
  /// **'Defeat! Team {winnerTeamName} captured the flag!'**
  String notificationDefeatCtfKnown(String winnerTeamName);

  /// No description provided for @notificationDefeatCtfUnknown.
  ///
  /// In en, this message translates to:
  /// **'Defeat! The opposing team captured the flag!'**
  String get notificationDefeatCtfUnknown;

  /// No description provided for @notificationDefeatClassicKnown.
  ///
  /// In en, this message translates to:
  /// **'Defeat! {winnerName} won three combats'**
  String notificationDefeatClassicKnown(String winnerName);

  /// No description provided for @notificationDefeatClassicUnknown.
  ///
  /// In en, this message translates to:
  /// **'Defeat! A player won three combats'**
  String get notificationDefeatClassicUnknown;

  /// No description provided for @notificationGameAbandoned.
  ///
  /// In en, this message translates to:
  /// **'Abandoned'**
  String get notificationGameAbandoned;

  /// No description provided for @notificationGameCanceled.
  ///
  /// In en, this message translates to:
  /// **'Game cancelled due to lack of players'**
  String get notificationGameCanceled;

  /// No description provided for @notificationGameLeft.
  ///
  /// In en, this message translates to:
  /// **'You left the game!'**
  String get notificationGameLeft;

  /// No description provided for @gameSessionPopupUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gameSessionPopupUnderstood;

  /// No description provided for @notificationDisconnectAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic disconnect'**
  String get notificationDisconnectAutomatic;

  /// No description provided for @notificationTurnStart.
  ///
  /// In en, this message translates to:
  /// **'{playerName}\'s turn starts in {seconds} seconds!'**
  String notificationTurnStart(String playerName, int seconds);

  /// No description provided for @playerHudMovements.
  ///
  /// In en, this message translates to:
  /// **'{count} movements'**
  String playerHudMovements(int count);

  /// No description provided for @playerHudActions.
  ///
  /// In en, this message translates to:
  /// **'{count} actions'**
  String playerHudActions(int count);

  /// No description provided for @playerHudStatsSection.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get playerHudStatsSection;

  /// No description provided for @playerHudDiceSection.
  ///
  /// In en, this message translates to:
  /// **'DICE'**
  String get playerHudDiceSection;

  /// No description provided for @statHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get statHealth;

  /// No description provided for @statSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get statSpeed;

  /// No description provided for @statAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get statAttack;

  /// No description provided for @statDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get statDefense;

  /// No description provided for @gameSessionInfoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get gameSessionInfoPlayers;

  /// No description provided for @gameSessionInfoActivePlayer.
  ///
  /// In en, this message translates to:
  /// **'Active player'**
  String get gameSessionInfoActivePlayer;

  /// No description provided for @gameSessionInfoBoardSize.
  ///
  /// In en, this message translates to:
  /// **'Board size'**
  String get gameSessionInfoBoardSize;

  /// No description provided for @gameSessionInfoContinue.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get gameSessionInfoContinue;

  /// No description provided for @gameSessionInfoQuit.
  ///
  /// In en, this message translates to:
  /// **'quit'**
  String get gameSessionInfoQuit;

  /// No description provided for @toggleDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug mode activated'**
  String get toggleDebugMode;

  /// No description provided for @itemAdrenalineName.
  ///
  /// In en, this message translates to:
  /// **'Adrenaline'**
  String get itemAdrenalineName;

  /// No description provided for @itemAdrenalineDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds 2 health points'**
  String get itemAdrenalineDesc;

  /// No description provided for @itemVodkaName.
  ///
  /// In en, this message translates to:
  /// **'Vodka'**
  String get itemVodkaName;

  /// No description provided for @itemVodkaDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds 2 attack points, removes 1 speed point'**
  String get itemVodkaDesc;

  /// No description provided for @itemPropagandaName.
  ///
  /// In en, this message translates to:
  /// **'Propaganda'**
  String get itemPropagandaName;

  /// No description provided for @itemPropagandaDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds 5 attack and 5 defense if player has less than 3 health points'**
  String get itemPropagandaDesc;

  /// No description provided for @itemBarbedWireName.
  ///
  /// In en, this message translates to:
  /// **'Barbed Wire'**
  String get itemBarbedWireName;

  /// No description provided for @itemBarbedWireDesc.
  ///
  /// In en, this message translates to:
  /// **'Fleeing is impossible for the opponent, only if you initiated the combat'**
  String get itemBarbedWireDesc;

  /// No description provided for @itemCamouflageName.
  ///
  /// In en, this message translates to:
  /// **'Camouflage'**
  String get itemCamouflageName;

  /// No description provided for @itemCamouflageDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows moving to any tile for 1 action point'**
  String get itemCamouflageDesc;

  /// No description provided for @itemWaterproofBootsName.
  ///
  /// In en, this message translates to:
  /// **'Waterproof Boots'**
  String get itemWaterproofBootsName;

  /// No description provided for @itemWaterproofBootsDesc.
  ///
  /// In en, this message translates to:
  /// **'Moving to another tile costs 1 movement point'**
  String get itemWaterproofBootsDesc;

  /// No description provided for @itemAirStrikeName.
  ///
  /// In en, this message translates to:
  /// **'Air Strike'**
  String get itemAirStrikeName;

  /// No description provided for @itemAirStrikeDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows ranged attacks'**
  String get itemAirStrikeDesc;

  /// No description provided for @itemTorchName.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get itemTorchName;

  /// No description provided for @itemTorchDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds 1 defense and 1 attack point when under the light of a torch'**
  String get itemTorchDesc;

  /// No description provided for @dropTorchButton.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get dropTorchButton;

  /// No description provided for @itemRandomName.
  ///
  /// In en, this message translates to:
  /// **'Random Item'**
  String get itemRandomName;

  /// No description provided for @itemRandomDesc.
  ///
  /// In en, this message translates to:
  /// **'A random item revealed during the game'**
  String get itemRandomDesc;

  /// No description provided for @itemFlagName.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get itemFlagName;

  /// No description provided for @itemFlagDesc.
  ///
  /// In en, this message translates to:
  /// **'A flag to bring back to base'**
  String get itemFlagDesc;

  /// No description provided for @itemSpawnName.
  ///
  /// In en, this message translates to:
  /// **'Spawn Point'**
  String get itemSpawnName;

  /// No description provided for @itemSpawnDesc.
  ///
  /// In en, this message translates to:
  /// **'A campfire serving as base'**
  String get itemSpawnDesc;

  /// No description provided for @tileSnowName.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get tileSnowName;

  /// No description provided for @tileTreeName.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get tileTreeName;

  /// No description provided for @tileStoneName.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get tileStoneName;

  /// No description provided for @tileIceName.
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get tileIceName;

  /// No description provided for @tileWaterName.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get tileWaterName;

  /// No description provided for @tileDoorName.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get tileDoorName;

  /// No description provided for @tileWallName.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get tileWallName;

  /// No description provided for @tileCornerName.
  ///
  /// In en, this message translates to:
  /// **'Corner'**
  String get tileCornerName;

  /// No description provided for @tileIntersectionName.
  ///
  /// In en, this message translates to:
  /// **'Intersection'**
  String get tileIntersectionName;

  /// No description provided for @tileTrapName.
  ///
  /// In en, this message translates to:
  /// **'Trap'**
  String get tileTrapName;

  /// No description provided for @tileTeleportPadName.
  ///
  /// In en, this message translates to:
  /// **'Teleport Pad'**
  String get tileTeleportPadName;

  /// No description provided for @tileSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'A snow tile'**
  String get tileSnowDesc;

  /// No description provided for @tileTreeDesc.
  ///
  /// In en, this message translates to:
  /// **'A tree that cannot be climbed'**
  String get tileTreeDesc;

  /// No description provided for @tileStoneDesc.
  ///
  /// In en, this message translates to:
  /// **'A large stone blocking the path'**
  String get tileStoneDesc;

  /// No description provided for @tileIceDesc.
  ///
  /// In en, this message translates to:
  /// **'An ice tile'**
  String get tileIceDesc;

  /// No description provided for @tileWaterDesc.
  ///
  /// In en, this message translates to:
  /// **'A water tile'**
  String get tileWaterDesc;

  /// No description provided for @tileDoorDesc.
  ///
  /// In en, this message translates to:
  /// **'A door that can be opened or closed'**
  String get tileDoorDesc;

  /// No description provided for @tileWallDesc.
  ///
  /// In en, this message translates to:
  /// **'An impassable wall'**
  String get tileWallDesc;

  /// No description provided for @tileCornerDesc.
  ///
  /// In en, this message translates to:
  /// **'An impassable corner'**
  String get tileCornerDesc;

  /// No description provided for @tileIntersectionDesc.
  ///
  /// In en, this message translates to:
  /// **'An impassable intersection'**
  String get tileIntersectionDesc;

  /// No description provided for @tileTrapDesc.
  ///
  /// In en, this message translates to:
  /// **'A trap that slows movement'**
  String get tileTrapDesc;

  /// No description provided for @tileTeleportPadDesc.
  ///
  /// In en, this message translates to:
  /// **'A teleport pad that leads to another teleport pad'**
  String get tileTeleportPadDesc;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get unknownError;

  /// No description provided for @gameNotFound.
  ///
  /// In en, this message translates to:
  /// **'The game has been deleted.'**
  String get gameNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection problem'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;
}

class _GameSessionLocalizationsDelegate
    extends LocalizationsDelegate<GameSessionLocalizations> {
  const _GameSessionLocalizationsDelegate();

  @override
  Future<GameSessionLocalizations> load(Locale locale) {
    return SynchronousFuture<GameSessionLocalizations>(
      lookupGameSessionLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_GameSessionLocalizationsDelegate old) => false;
}

GameSessionLocalizations lookupGameSessionLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return GameSessionLocalizationsEn();
    case 'fr':
      return GameSessionLocalizationsFr();
  }

  throw FlutterError(
    'GameSessionLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
