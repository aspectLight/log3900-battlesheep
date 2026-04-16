// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'character_creation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CharacterCreationLocalizationsEn extends CharacterCreationLocalizations {
  CharacterCreationLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get backToCreateGame => 'Create game';

  @override
  String get createPlayerTitle => 'Create player';

  @override
  String get charactersSectionTitle => 'Characters';

  @override
  String get chooseCharacterPlaceholder => 'Choose your character';

  @override
  String get characterNameLabel => 'Your name';

  @override
  String get createGameButton => 'Create game';

  @override
  String get accessWaitingRoomButton => 'Access waiting room';

  @override
  String get playerHudStatsSection => 'Stats';

  @override
  String get statHealth => 'Health';

  @override
  String get statHealthDescription =>
      'Represents the character hit points. If it reaches zero, the player is defeated.';

  @override
  String get statSpeed => 'Speed';

  @override
  String get statSpeedDescription =>
      'Determines turn order in combat and movement points per turn.';

  @override
  String get statAttack => 'Attack';

  @override
  String get statAttackDescription => 'Determines damage dealt to opponents.';

  @override
  String get statDefense => 'Defense';

  @override
  String get statDefenseDescription =>
      'Represents the ability to block damage from enemy attacks.';

  @override
  String get characterCreationValidationMessage =>
      'Veillez à choisir un personnage et les 2 bonus.';

  @override
  String get selectedGameHiddenOrDeleted =>
      'The selected game is hidden or deleted.';

  @override
  String get reserveCharacterFailed => 'Could not reserve character.';
}
