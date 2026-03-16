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
  String get gamePlayersListPlaying => 'Joue...';

  @override
  String get gamePlayersListVirtual => 'Virtuel';

  @override
  String get gameTimerLabel => 'Tour en cours';

  @override
  String get gameDebugMode => 'La partie est en mode débogage';

  @override
  String get gameActionCancel => 'Annuler';

  @override
  String get gameActionAct => 'Agir';

  @override
  String get gameActionForwardTurn => 'Fin de tour';

  @override
  String get gameCellDetailCost => 'Coût';

  @override
  String get gameCellDetailDescription => 'Description';

  @override
  String get gameCellDetailYou => 'Vous';

  @override
  String combatYourTurn(Object countdown) {
    return 'À vous de jouer! Il vous reste: $countdown secondes';
  }

  @override
  String combatYourTurnIn(Object countdown) {
    return 'C\'est votre tour dans: $countdown secondes';
  }

  @override
  String combatFlightAttemptsLeft(Object count) {
    return '$count tentatives d\'évasion restantes';
  }

  @override
  String get combatYourDefense => 'Votre défense';

  @override
  String get combatYourAttack => 'Votre attaque';

  @override
  String get combatEnemyAttack => 'Attaque adverse';

  @override
  String get combatEnemyDefense => 'Défense adverse';

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
  String get combatBarbedWireTitle => 'Barbed wire';

  @override
  String get combatBarbedWireBlockedMessage =>
      'La fuite est empêché par l\'adversaire';

  @override
  String get combatNotificationVictory => 'Victoire!';

  @override
  String get combatNotificationVictoryMessage => 'Vous avez gagné le combat !';

  @override
  String get combatNotificationDefeat => 'Défaite';

  @override
  String combatNotificationDefeatMessage(Object winnerName) {
    return '$winnerName a gagné le combat!';
  }

  @override
  String get combatNotificationFlightSuccessTitle =>
      'Tentative de fuite réussie!';

  @override
  String get combatNotificationFlightSuccess => 'Vous avez réussi à fuir!';

  @override
  String combatNotificationEnemyFled(Object enemyName) {
    return '$enemyName a réussi à fuir!';
  }

  @override
  String get combatStartedNotificationTitle => 'Combat commencé';

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
  String get notificationVictoryCtf =>
      'Victoire! Ton équipe a capturé le drapeau !';

  @override
  String get notificationVictoryClassic =>
      'Victoire! Tu as gagné trois combats';

  @override
  String notificationDefeatCtf(Object winnerTeamName) {
    return 'Défaite! $winnerTeamName a capturé le drapeau !';
  }

  @override
  String notificationDefeatClassic(Object winnerName) {
    return 'Défaite! $winnerName a gagné trois combats';
  }

  @override
  String get notificationGameAbandoned => 'Partie abandonnée';

  @override
  String get notificationDisconnectAutomatic => 'Déconnexion automatique';

  @override
  String notificationTurnStart(Object playerName, Object seconds) {
    return 'Tour de $playerName (${seconds}s)';
  }

  @override
  String playerHudMovements(Object count) {
    return '$count Déplacements';
  }

  @override
  String playerHudActions(Object count) {
    return '$count Actions';
  }

  @override
  String get playerHudStatsSection => 'Statistiques';

  @override
  String get playerHudDiceSection => 'Dés';

  @override
  String get statHealth => 'Santé';

  @override
  String get statSpeed => 'Vitesse';

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
  String get gameSessionInfoContinue => 'Continuer';

  @override
  String get gameSessionInfoQuit => 'Quitter';

  @override
  String get toggleDebugMode => 'La partie est en mode débogage';

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
  String get itemPropagandaName => 'Propaganda';

  @override
  String get itemPropagandaDesc =>
      'Ajoute 5 points d\'attaque et 5 points de défense si le joueur est à moins de 3 points de vie';

  @override
  String get itemBarbedWireName => 'Barbed Wire';

  @override
  String get itemBarbedWireDesc =>
      'La fuite est impossible pour l\'adversaire, seulement si vous êtes l\'instigateur du combat';

  @override
  String get itemCamouflageName => 'Camouflage';

  @override
  String get itemCamouflageDesc =>
      'Permet de se déplacer vers n\'importe quelle case pour 1 point d\'action';

  @override
  String get itemWaterproofBootsName => 'Waterproof Boots';

  @override
  String get itemWaterproofBootsDesc =>
      'Les déplacements vers une autre case coûtent 1 point de mouvement';

  @override
  String get itemAirStrikeName => 'Air Strike';

  @override
  String get itemAirStrikeDesc => 'Permet d\'attaquer à distance';

  @override
  String get itemRandomName => 'Random';

  @override
  String get itemRandomDesc =>
      'Un item aléatoire qui sera révélé en pleine partie';

  @override
  String get itemFlagName => 'Flag';

  @override
  String get itemFlagDesc => 'Un drapeau à ramener à la base';

  @override
  String get itemSpawnName => 'Spawn';

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
  String get tileSnowDesc => 'Une tuile de neige basique';

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
  String get tileCornerDesc => 'Un mur infranchissable';

  @override
  String get tileIntersectionDesc => 'Un mur infranchissable';

  @override
  String get unknownError => 'Une erreur inconnue est survenue';

  @override
  String get gameNotFound => 'Partie introuvable';

  @override
  String get networkError => 'Problème de connexion réseau';

  @override
  String get serverError => 'Erreur du serveur';
}
