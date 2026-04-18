// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'waiting_room_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class WaitingRoomLocalizationsEn extends WaitingRoomLocalizations {
  WaitingRoomLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get back => 'Leave game';

  @override
  String get waitingRoomTitle => 'Waiting room';

  @override
  String get waitingRoom => 'WAITING ROOM';

  @override
  String get gameCode => 'Game Code :';

  @override
  String get waitingRoomGameCode => 'Code of the game :';

  @override
  String get waitingRoomWaitingForPlayers => 'Waiting for players...';

  @override
  String get waitingForPlayers => 'Waiting For Players...';

  @override
  String get waitingRoomWaitingForHost => 'Waiting for the game host...';

  @override
  String get waitingForHost => 'Waiting for the game host...';

  @override
  String get waitingRoomUnlockRoom => 'Unlock room';

  @override
  String get unlockRoom => 'Unlock room';

  @override
  String get waitingRoomLockRoom => 'Lock room';

  @override
  String get lockRoom => 'Lock room';

  @override
  String get startGame => 'Start game';

  @override
  String get waitingRoomAddVirtualPlayer => 'Add virtual player';

  @override
  String get waitingRoomDropInDropOut => 'Drop-in/Drop-out';

  @override
  String get addVirtualPlayer => 'Add virtual player';

  @override
  String get selectVirtualProfile => 'Select the virtual player\'s profile:';

  @override
  String get waitingRoomVirtualPlayerName => 'Virtual player name';

  @override
  String get waitingRoomVirtualPlayerCharacter => 'Character';

  @override
  String get waitingRoomVirtualPlayerType => 'Type';

  @override
  String get aggressive => 'Aggressive';

  @override
  String get defensive => 'Defensive';

  @override
  String get waitingRoomAddButton => 'Add';

  @override
  String get confirmLeaveRoom => 'Do you really want to leave the game?';

  @override
  String get confirmLockRoom => 'Do you really want to lock the room?';

  @override
  String get confirmUnlockRoom => 'Do you really want to unlock the room?';

  @override
  String get confirmKickPlayer => 'Do you really want to kick this player?';

  @override
  String get waitingRoomRoomNotFound => 'Game not found';

  @override
  String get waitingRoomRoomLocked => 'Game is locked';

  @override
  String get waitingRoomCharacterAlreadyReserved => 'Character already taken';

  @override
  String get waitingRoomPlayerAlreadyInRoom =>
      'This player is already in the room';

  @override
  String get waitingRoomPlayerKicked => 'You have been kicked';

  @override
  String get waitingRoomMaxPlayerLimitReached => 'Maximum player limit reached';

  @override
  String get waitingRoomStartGameFailed => 'Could not start game';

  @override
  String get waitingRoomStatHealth => 'Health';

  @override
  String get waitingRoomStatSpeed => 'Speed';

  @override
  String get waitingRoomStatAttack => 'Attack';

  @override
  String get waitingRoomStatDefense => 'Defense';

  @override
  String get waitingRoomBalanceLabel => 'Balance:';

  @override
  String get waitingRoomEntryFeeLabel => 'Entry fee:';

  @override
  String get waitingRoomFriendsOnlyLabel => 'Friends only:';

  @override
  String get gameNotFound => 'Game not found';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get waitingRoomWelcomeMessage =>
      'Bienvenue dans la salle d\'attente, partagez le code de la partie avec vos amis !';

  @override
  String get waitingRoomJoinQrLabel => 'QR code with the 4-digit game code';
}
