// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'character_creation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class CharacterCreationLocalizationsFr extends CharacterCreationLocalizations {
  CharacterCreationLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get backToCreateGame => 'Créer une partie';

  @override
  String get createPlayerTitle => 'Créer un joueur';

  @override
  String get charactersSectionTitle => 'Personnages';

  @override
  String get chooseCharacterPlaceholder => 'Choisissez votre personnage';

  @override
  String get characterNameLabel => 'Votre nom';

  @override
  String get createGameButton => 'Créer la partie';

  @override
  String get accessWaitingRoomButton => 'Accéder à la salle d\'attente';

  @override
  String get playerHudStatsSection => 'Stats';

  @override
  String get statHealth => 'Vie';

  @override
  String get statHealthDescription =>
      'Représente les points de vie du personnage. S\'il tombe à zéro, le joueur est battu.';

  @override
  String get statSpeed => 'Rapidité';

  @override
  String get statSpeedDescription =>
      'Détermine l\'ordre de passage en combat et le nombre de points de mouvement par tour.';

  @override
  String get statAttack => 'Attaque';

  @override
  String get statAttackDescription =>
      'Détermine les dégâts infligés aux adversaires.';

  @override
  String get statDefense => 'Défense';

  @override
  String get statDefenseDescription =>
      'Représente la capacité à bloquer les dégâts des attaques ennemies.';

  @override
  String get characterCreationValidationMessage =>
      'Veillez à choisir un personnage et les 2 bonus.';

  @override
  String get selectedGameHiddenOrDeleted =>
      'Le jeu sélectionné est caché ou supprimé.';

  @override
  String get gameStartedWhileCreating =>
      'La partie a commencé sans vous. Retour au menu principal.';

  @override
  String get reserveCharacterFailed => 'Impossible de réserver le personnage.';
}
