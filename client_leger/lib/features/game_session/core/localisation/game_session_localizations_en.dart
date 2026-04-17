// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class GameSessionLocalizationsEn extends GameSessionLocalizations {
  GameSessionLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gameContentSoon => 'Game content coming soon...';

  @override
  String get gameInventoryFullDiscardTitle => 'Inventory full';

  @override
  String get gameTrapTitle => 'You are on a trap!';

  @override
  String get gameTrapDescriptionCanAvoid =>
      'You can avoid the trap or try to cross it.';

  @override
  String get gameTrapDescriptionMustTraverse =>
      'You don\'t have enough movement points to avoid the trap. You must cross it.';

  @override
  String get gameTrapAvoid => 'Avoid';

  @override
  String get gameTrapTraverse => 'Cross';

  @override
  String get gamePlayersListPlaying => 'Playing...';

  @override
  String get gamePlayersListVirtual => 'Virtual';

  @override
  String gameTimerCurrentTurn(int seconds) {
    return 'Current turn: $seconds';
  }

  @override
  String get gameDebugMode => 'Debug mode activated';

  @override
  String get gameActionCancel => 'Cancel';

  @override
  String get gameActionAct => 'Act';

  @override
  String get gameActionForwardTurn => 'End turn';

  @override
  String get gameCellDetailCost => 'COST';

  @override
  String get gameCellDetailDescription => 'DESCRIPTION';

  @override
  String get gameCellDetailYou => 'You';

  @override
  String combatYourTurn(int countdown) {
    return 'Your turn! You have: $countdown seconds left';
  }

  @override
  String combatYourTurnIn(int countdown) {
    return 'Your turn in: $countdown seconds';
  }

  @override
  String combatFlightAttemptsLeft(int count) {
    return '$count escape attempts remaining';
  }

  @override
  String get combatYourDefense => 'YOUR DEFENSE';

  @override
  String get combatYourAttack => 'YOUR ATTACK';

  @override
  String get combatEnemyAttack => 'ENEMY ATTACK';

  @override
  String get combatEnemyDefense => 'ENEMY DEFENSE';

  @override
  String get combatFlee => 'Flee!';

  @override
  String get combatAttack => 'Attack';

  @override
  String get combatMissTitle => 'Missed!';

  @override
  String get combatEvadedTitle => 'Dodged!';

  @override
  String get combatFlightAttemptTitle => 'Escape attempt!';

  @override
  String get combatFlightAttemptSuccess => 'You managed to flee!';

  @override
  String get combatFlightAttemptFailure => 'You failed to flee!';

  @override
  String get combatBarbedWireTitle => 'Barbed Wire';

  @override
  String get combatBarbedWireBlockedMessage =>
      'Fleeing is impossible for the opponent, only if you initiated the combat';

  @override
  String get combatNotificationVictory => 'Victory!';

  @override
  String get combatNotificationVictoryMessage => 'You won the fight!';

  @override
  String get combatNotificationDefeat => 'Defeat';

  @override
  String combatNotificationDefeatMessage(String winnerName) {
    return '$winnerName won the fight!';
  }

  @override
  String get combatNotificationFlightSuccessTitle => 'Escape successful!';

  @override
  String get combatNotificationFlightSuccess => 'You managed to flee!';

  @override
  String combatNotificationEnemyFled(String enemyName) {
    return '$enemyName managed to flee!';
  }

  @override
  String get combatStartedNotificationTitle => 'Combat started';

  @override
  String combatStartedNotificationMessage(
    String attackerName,
    String defenderName,
  ) {
    return '$attackerName vs $defenderName';
  }

  @override
  String get combatStatAttack => 'Attack';

  @override
  String get combatStatDefense => 'Defense';

  @override
  String get combatStatSpeed => 'Speed';

  @override
  String get combatStatHealth => 'Health';

  @override
  String get notificationVictoryCtf => 'Victory! Your team captured the flag!';

  @override
  String get notificationVictoryClassic => 'Victory! You won three combats';

  @override
  String notificationDefeatCtfKnown(String winnerTeamName) {
    return 'Defeat! Team $winnerTeamName captured the flag!';
  }

  @override
  String get notificationDefeatCtfUnknown =>
      'Defeat! The opposing team captured the flag!';

  @override
  String notificationDefeatClassicKnown(String winnerName) {
    return 'Defeat! $winnerName won three combats';
  }

  @override
  String get notificationDefeatClassicUnknown =>
      'Defeat! A player won three combats';

  @override
  String get notificationGameAbandoned => 'Abandoned';

  @override
  String get notificationGameCanceled =>
      'Game cancelled due to lack of players';

  @override
  String get notificationGameLeft => 'You left the game!';

  @override
  String get gameSessionPopupUnderstood => 'Got it';

  @override
  String get notificationDisconnectAutomatic => 'Automatic disconnect';

  @override
  String notificationTurnStart(String playerName, int seconds) {
    return '$playerName\'s turn starts in $seconds seconds!';
  }

  @override
  String playerHudMovements(int count) {
    return '$count movements';
  }

  @override
  String playerHudActions(int count) {
    return '$count actions';
  }

  @override
  String get playerHudStatsSection => 'Stats';

  @override
  String get playerHudDiceSection => 'DICE';

  @override
  String get statHealth => 'Health';

  @override
  String get statSpeed => 'Speed';

  @override
  String get statAttack => 'Attack';

  @override
  String get statDefense => 'Defense';

  @override
  String get gameSessionInfoPlayers => 'Players';

  @override
  String get gameSessionInfoActivePlayer => 'Active player';

  @override
  String get gameSessionInfoBoardSize => 'Board size';

  @override
  String get gameSessionInfoContinue => 'continue';

  @override
  String get gameSessionInfoQuit => 'quit';

  @override
  String get toggleDebugMode => 'Debug mode activated';

  @override
  String get itemAdrenalineName => 'Adrenaline';

  @override
  String get itemAdrenalineDesc => 'Adds 2 health points';

  @override
  String get itemVodkaName => 'Vodka';

  @override
  String get itemVodkaDesc => 'Adds 2 attack points, removes 1 speed point';

  @override
  String get itemPropagandaName => 'Propaganda';

  @override
  String get itemPropagandaDesc =>
      'Adds 5 attack and 5 defense if player has less than 3 health points';

  @override
  String get itemBarbedWireName => 'Barbed Wire';

  @override
  String get itemBarbedWireDesc =>
      'Fleeing is impossible for the opponent, only if you initiated the combat';

  @override
  String get itemCamouflageName => 'Camouflage';

  @override
  String get itemCamouflageDesc =>
      'Allows moving to any tile for 1 action point';

  @override
  String get itemWaterproofBootsName => 'Waterproof Boots';

  @override
  String get itemWaterproofBootsDesc =>
      'Moving to another tile costs 1 movement point';

  @override
  String get itemAirStrikeName => 'Air Strike';

  @override
  String get itemAirStrikeDesc => 'Allows ranged attacks';

  @override
  String get itemTorchName => 'Torch';

  @override
  String get itemTorchDesc =>
      'Adds 1 defense and 1 attack point when under the light of a torch';

  @override
  String get dropTorchButton => 'Drop';

  @override
  String get itemRandomName => 'Random Item';

  @override
  String get itemRandomDesc => 'A random item revealed during the game';

  @override
  String get itemFlagName => 'Flag';

  @override
  String get itemFlagDesc => 'A flag to bring back to base';

  @override
  String get itemSpawnName => 'Spawn Point';

  @override
  String get itemSpawnDesc => 'A campfire serving as base';

  @override
  String get tileSnowName => 'Snow';

  @override
  String get tileTreeName => 'Tree';

  @override
  String get tileStoneName => 'Stone';

  @override
  String get tileIceName => 'Ice';

  @override
  String get tileWaterName => 'Water';

  @override
  String get tileDoorName => 'Door';

  @override
  String get tileWallName => 'Wall';

  @override
  String get tileCornerName => 'Corner';

  @override
  String get tileIntersectionName => 'Intersection';

  @override
  String get tileTrapName => 'Trap';

  @override
  String get tileTeleportPadName => 'Teleport Pad';

  @override
  String get tileSnowDesc => 'A snow tile';

  @override
  String get tileTreeDesc => 'A tree that cannot be climbed';

  @override
  String get tileStoneDesc => 'A large stone blocking the path';

  @override
  String get tileIceDesc => 'An ice tile';

  @override
  String get tileWaterDesc => 'A water tile';

  @override
  String get tileDoorDesc => 'A door that can be opened or closed';

  @override
  String get tileWallDesc => 'An impassable wall';

  @override
  String get tileCornerDesc => 'An impassable corner';

  @override
  String get tileIntersectionDesc => 'An impassable intersection';

  @override
  String get tileTrapDesc => 'A trap that slows movement';

  @override
  String get tileTeleportPadDesc =>
      'A teleport pad that leads to another teleport pad';

  @override
  String get unknownError => 'An error occurred. Please try again.';

  @override
  String get gameNotFound => 'The game has been deleted.';

  @override
  String get networkError => 'Network connection problem';

  @override
  String get serverError => 'Server error';
}
