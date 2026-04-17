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
  String get gameTrapTitle => 'Trap';

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
  String get gameTimerLabel => 'Turn in progress';

  @override
  String get gameDebugMode => 'Game is in debug mode';

  @override
  String get gameActionCancel => 'Cancel';

  @override
  String get gameActionAct => 'Act';

  @override
  String get gameActionForwardTurn => 'End turn';

  @override
  String get gameCellDetailCost => 'Cost';

  @override
  String get gameCellDetailDescription => 'Description';

  @override
  String get gameCellDetailYou => 'You';

  @override
  String combatYourTurn(Object countdown) {
    return 'Your turn! You have $countdown seconds left';
  }

  @override
  String combatYourTurnIn(Object countdown) {
    return 'Your turn in $countdown seconds';
  }

  @override
  String combatFlightAttemptsLeft(Object count) {
    return '$count flight attempts left';
  }

  @override
  String get combatYourDefense => 'Your defense';

  @override
  String get combatYourAttack => 'Your attack';

  @override
  String get combatEnemyAttack => 'Enemy attack';

  @override
  String get combatEnemyDefense => 'Enemy defense';

  @override
  String get combatFlee => 'Flee!';

  @override
  String get combatAttack => 'Attack';

  @override
  String get combatMissTitle => 'Miss!';

  @override
  String get combatEvadedTitle => 'Evaded!';

  @override
  String get combatFlightAttemptTitle => 'Flight attempt!';

  @override
  String get combatFlightAttemptSuccess => 'You fled successfully!';

  @override
  String get combatFlightAttemptFailure => 'You failed to flee!';

  @override
  String get combatBarbedWireTitle => 'Barbed wire';

  @override
  String get combatBarbedWireBlockedMessage =>
      'Fleeing is prevented by the opponent';

  @override
  String get combatNotificationVictory => 'Victory';

  @override
  String get combatNotificationVictoryMessage => 'You won the combat!';

  @override
  String get combatNotificationDefeat => 'Defeat';

  @override
  String combatNotificationDefeatMessage(Object winnerName) {
    return '$winnerName won the combat!';
  }

  @override
  String get combatNotificationFlightSuccessTitle => 'Fled';

  @override
  String get combatNotificationFlightSuccess => 'You got away.';

  @override
  String combatNotificationEnemyFled(Object enemyName) {
    return '$enemyName fled.';
  }

  @override
  String get combatStartedNotificationTitle => 'Combat started';

  @override
  String combatStartedNotificationMessage(
    Object attackerName,
    Object defenderName,
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
  String notificationDefeatCtf(Object winnerTeamName) {
    return 'Defeat! $winnerTeamName captured the flag!';
  }

  @override
  String notificationDefeatClassic(Object winnerName) {
    return 'Defeat! $winnerName won three combats';
  }

  @override
  String get notificationGameAbandoned => 'Game abandoned';

  @override
  String get notificationGameCanceled => 'Game canceled';

  @override
  String get notificationGameLeft => 'You left the game!';

  @override
  String get gameSessionPopupUnderstood => 'Got it';

  @override
  String get notificationDisconnectAutomatic => 'Automatic disconnect';

  @override
  String notificationTurnStart(Object playerName, Object seconds) {
    return '$playerName\'s turn (${seconds}s)';
  }

  @override
  String playerHudMovements(Object count) {
    return '$count Movements';
  }

  @override
  String playerHudActions(Object count) {
    return '$count Actions';
  }

  @override
  String get playerHudStatsSection => 'Stats';

  @override
  String get playerHudDiceSection => 'Dice';

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
  String get gameSessionInfoContinue => 'Continue';

  @override
  String get gameSessionInfoQuit => 'Quit';

  @override
  String get toggleDebugMode => 'Game is in debug mode';

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
      'Flight is impossible for the opponent, only if you started the combat';

  @override
  String get itemCamouflageName => 'Camouflage';

  @override
  String get itemCamouflageDesc =>
      'Allows moving to any tile for 1 action point';

  @override
  String get itemWaterproofBootsName => 'Waterproof Boots';

  @override
  String get itemWaterproofBootsDesc =>
      'Movement to another tile costs 1 movement point';

  @override
  String get itemAirStrikeName => 'Air Strike';

  @override
  String get itemAirStrikeDesc => 'Allows attacking at range';

  @override
  String get itemTorchName => 'Torch';

  @override
  String get itemTorchDesc =>
      'A lit torch that improves your abilities in the light';

  @override
  String get dropTorchButton => 'Drop';

  @override
  String get itemRandomName => 'Random';

  @override
  String get itemRandomDesc => 'A random item revealed during the game';

  @override
  String get itemFlagName => 'Flag';

  @override
  String get itemFlagDesc => 'A flag to bring back to base';

  @override
  String get itemSpawnName => 'Spawn';

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
  String get tileTeleportPadName => 'Teleport pad';

  @override
  String get tileSnowDesc => 'A basic snow tile';

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
  String get tileCornerDesc => 'An impassable wall';

  @override
  String get tileIntersectionDesc => 'An impassable wall';

  @override
  String get tileTrapDesc => 'A trap that slows movement';

  @override
  String get tileTeleportPadDesc => 'Teleports you to the paired pad';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get gameNotFound => 'Game not found';

  @override
  String get networkError => 'Network connection problem';

  @override
  String get serverError => 'Server error';
}
