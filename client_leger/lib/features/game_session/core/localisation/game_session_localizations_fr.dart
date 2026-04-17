// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class GameSessionLocalizationsFr extends GameSessionLocalizations {
  GameSessionLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get gameContentSoon => 'Le contenu du jeu arrive bientôt...';

  @override
  String get gameInventoryFullDiscardTitle => 'Inventaire plein';

  @override
  String get gameTrapTitle => 'Vous êtes sur un piège!';

  @override
  String get gameTrapDescriptionCanAvoid =>
      'Vous pouvez éviter le piège ou tenter de le traverser.';

  @override
  String get gameTrapDescriptionMustTraverse =>
      'Vous n\'avez pas assez de points pour éviter le piège. Vous devez le traverser.';

  @override
  String get gameTrapAvoid => 'Éviter';

  @override
  String get gameTrapTraverse => 'Traverser';

  @override
  String get gamePlayersListPlaying => 'Joue...';

  @override
  String get gamePlayersListVirtual => 'Virtuel';

  @override
  String gameTimerCurrentTurn(int seconds) {
    return 'Tour en cours: $seconds';
  }

  @override
  String get gameDebugMode => 'Mode débogage activé';

  @override
  String get gameActionCancel => 'Annuler';

  @override
  String get gameActionAct => 'Agir';

  @override
  String get gameActionForwardTurn => 'Fin de tour';

  @override
  String get gameCellDetailCost => 'COST';

  @override
  String get gameCellDetailDescription => 'DESCRIPTION';

  @override
  String get gameCellDetailYou => 'Vous';

  @override
  String combatYourTurn(int countdown) {
    return 'À vous de jouer! Il vous reste: $countdown secondes';
  }

  @override
  String combatYourTurnIn(int countdown) {
    return 'C\'est votre tour dans: $countdown secondes';
  }

  @override
  String combatFlightAttemptsLeft(int count) {
    return '$count tentatives d\'évasion restantes';
  }

  @override
  String get combatYourDefense => 'VOTRE DÉFENSE';

  @override
  String get combatYourAttack => 'VOTRE ATTAQUE';

  @override
  String get combatEnemyAttack => 'ATTAQUE ADVERSE';

  @override
  String get combatEnemyDefense => 'DÉFENSE ADVERSE';

  @override
  String get combatFlee => 'Fuir !';

  @override
  String get combatAttack => 'Attaquer';

  @override
  String get combatMissTitle => 'Raté!';

  @override
  String get combatEvadedTitle => 'Esquivé!';

  @override
  String get combatFlightAttemptTitle => 'Tentative de fuite !';

  @override
  String get combatFlightAttemptSuccess => 'Vous avez réussi à fuir!';

  @override
  String get combatFlightAttemptFailure => 'Vous n\'avez pas réussi à fuir!';

  @override
  String get combatBarbedWireTitle => 'Fil barbelé';

  @override
  String get combatBarbedWireBlockedMessage =>
      'La fuite est impossible pour l\'adversaire, seulement si vous êtes l\'instigateur du combat';

  @override
  String get combatNotificationVictory => 'Victoire!';

  @override
  String get combatNotificationVictoryMessage => 'Vous avez gagné le combat!';

  @override
  String get combatNotificationDefeat => 'Défaite';

  @override
  String combatNotificationDefeatMessage(String winnerName) {
    return '$winnerName a gagné le combat!';
  }

  @override
  String get combatNotificationFlightSuccessTitle =>
      'Tentative de fuite réussie!';

  @override
  String get combatNotificationFlightSuccess => 'Vous avez réussi à fuir!';

  @override
  String combatNotificationEnemyFled(String enemyName) {
    return '$enemyName a réussi à fuir!';
  }

  @override
  String get combatStartedNotificationTitle => 'Combat commencé';

  @override
  String combatStartedNotificationMessage(
    String attackerName,
    String defenderName,
  ) {
    return '$attackerName vs $defenderName';
  }

  @override
  String get combatStatAttack => 'Attaque';

  @override
  String get combatStatDefense => 'Défense';

  @override
  String get combatStatSpeed => 'Rapidité';

  @override
  String get combatStatHealth => 'Vie';

  @override
  String get notificationVictoryCtf =>
      'Victoire ! Ton équipe a capturé le drapeau !';

  @override
  String get notificationVictoryClassic =>
      'Victoire ! Tu as gagné trois combats';

  @override
  String notificationDefeatCtfKnown(String winnerTeamName) {
    return 'Défaite ! L\'équipe $winnerTeamName a capturé le drapeau !';
  }

  @override
  String get notificationDefeatCtfUnknown =>
      'Défaite ! L\'équipe adverse a capturé le drapeau !';

  @override
  String notificationDefeatClassicKnown(String winnerName) {
    return 'Défaite ! $winnerName a gagné trois combats';
  }

  @override
  String get notificationDefeatClassicUnknown =>
      'Défaite ! Un joueur a gagné trois combats';

  @override
  String get notificationGameAbandoned => 'Abandonnée';

  @override
  String get notificationGameCanceled => 'Partie annulée par manque de joueurs';

  @override
  String get notificationGameLeft => 'Vous avez quitté la partie!';

  @override
  String get gameSessionPopupUnderstood => 'Compris';

  @override
  String get notificationDisconnectAutomatic => 'Déconnexion automatique';

  @override
  String notificationTurnStart(String playerName, int seconds) {
    return 'Le tour de $playerName commence dans $seconds secondes !';
  }

  @override
  String playerHudMovements(int count) {
    return '$count déplacements';
  }

  @override
  String playerHudActions(int count) {
    return '$count actions';
  }

  @override
  String get playerHudStatsSection => 'Stats';

  @override
  String get playerHudDiceSection => 'DÉS';

  @override
  String get statHealth => 'Vie';

  @override
  String get statSpeed => 'Rapidité';

  @override
  String get statAttack => 'Attaque';

  @override
  String get statDefense => 'Défense';

  @override
  String get gameSessionInfoPlayers => 'Joueurs';

  @override
  String get gameSessionInfoActivePlayer => 'Joueur actif';

  @override
  String get gameSessionInfoBoardSize => 'Taille du plateau';

  @override
  String get gameSessionInfoContinue => 'continuer';

  @override
  String get gameSessionInfoQuit => 'quitter';

  @override
  String get toggleDebugMode => 'Mode débogage activé';

  @override
  String get itemAdrenalineName => 'Adrénaline';

  @override
  String get itemAdrenalineDesc => 'Ajoute 2 points de vie';

  @override
  String get itemVodkaName => 'Vodka';

  @override
  String get itemVodkaDesc =>
      'Ajoute 2 points d\'attaque, enlève 1 point de rapidité';

  @override
  String get itemPropagandaName => 'Propagande';

  @override
  String get itemPropagandaDesc =>
      'Ajoute 5 points d\'attaque et 5 points de défense si le joueur est à moins de 3 points de vie';

  @override
  String get itemBarbedWireName => 'Fil barbelé';

  @override
  String get itemBarbedWireDesc =>
      'La fuite est impossible pour l\'adversaire, seulement si vous êtes l\'instigateur du combat';

  @override
  String get itemCamouflageName => 'Camouflage';

  @override
  String get itemCamouflageDesc =>
      'Permet de se déplacer vers n\'importe quelle case pour 1 point d\'action';

  @override
  String get itemWaterproofBootsName => 'Bottes imperméables';

  @override
  String get itemWaterproofBootsDesc =>
      'Les déplacements vers une autre case coûtent 1 point de mouvement';

  @override
  String get itemAirStrikeName => 'Frappe aérienne';

  @override
  String get itemAirStrikeDesc => 'Permet d\'attaquer à distance';

  @override
  String get itemTorchName => 'Torche';

  @override
  String get itemTorchDesc =>
      'Ajoute 1 point de défense et 1 points d\'attaque lorsque sous la lumière d\'une torche';

  @override
  String get dropTorchButton => 'Déposer';

  @override
  String get itemRandomName => 'Objet aléatoire';

  @override
  String get itemRandomDesc =>
      'Un item aléatoire qui sera révélé en pleine partie';

  @override
  String get itemFlagName => 'Drapeau';

  @override
  String get itemFlagDesc => 'Un drapeau à ramener à la base';

  @override
  String get itemSpawnName => 'Point d\'apparition';

  @override
  String get itemSpawnDesc => 'Un feu de camp servant de base';

  @override
  String get tileSnowName => 'Neige';

  @override
  String get tileTreeName => 'Arbre';

  @override
  String get tileStoneName => 'Pierre';

  @override
  String get tileIceName => 'Glace';

  @override
  String get tileWaterName => 'Eau';

  @override
  String get tileDoorName => 'Porte';

  @override
  String get tileWallName => 'Mur';

  @override
  String get tileCornerName => 'Coin';

  @override
  String get tileIntersectionName => 'Intersection';

  @override
  String get tileTrapName => 'Piège';

  @override
  String get tileTeleportPadName => 'Téléporteur';

  @override
  String get tileSnowDesc => 'Une tuile de neige';

  @override
  String get tileTreeDesc => 'Un arbre qui ne peut pas être grimpé';

  @override
  String get tileStoneDesc => 'Une grande pierre qui bloque la route';

  @override
  String get tileIceDesc => 'Une tuile de glace';

  @override
  String get tileWaterDesc => 'Une tuile d\'eau';

  @override
  String get tileDoorDesc => 'Une porte qui peut être ouverte ou fermée';

  @override
  String get tileWallDesc => 'Un mur infranchissable';

  @override
  String get tileCornerDesc => 'Un coin infranchissable';

  @override
  String get tileIntersectionDesc => 'Une intersection infranchissable';

  @override
  String get tileTrapDesc => 'Un piège qui freine les déplacements';

  @override
  String get tileTeleportPadDesc => 'Un téléporteur vers un autre téléporteur';

  @override
  String get unknownError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get gameNotFound => 'Le jeu a été supprimé.';

  @override
  String get networkError => 'Problème de connexion réseau';

  @override
  String get serverError => 'Erreur du serveur';
}
