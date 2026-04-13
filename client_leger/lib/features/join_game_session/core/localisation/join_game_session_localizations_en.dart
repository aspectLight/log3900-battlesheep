// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'join_game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class JoinGameSessionLocalizationsEn extends JoinGameSessionLocalizations {
  JoinGameSessionLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get mainMenu => 'Main menu';

  @override
  String get ok => 'OK';

  @override
  String get joinGameTitle => 'Join a game';

  @override
  String get joinGameSubtitle => 'Enter the 4-digit game code';

  @override
  String get joinGameDescription =>
      'You can find this code in the waiting room of the game';

  @override
  String get joinGameButton => 'Access waiting room';

  @override
  String get joinGameFailed => 'Failed to join game';

  @override
  String get joinGameNoRooms => 'No available game';

  @override
  String get joinGameRoomListPreview => 'Preview';

  @override
  String get joinGameRoomListPlayers => 'Players';

  @override
  String get joinGameRoomListSize => 'Size';

  @override
  String get joinGameRoomListStatus => 'Status';

  @override
  String get joinGameRoomListMode => 'Mode';

  @override
  String get joinGameRoomListAccessibility => 'Accessibility';

  @override
  String get joinGameRoomListCode => 'Code';

  @override
  String get joinGameStatusWaiting => 'Waiting';

  @override
  String get joinGameStatusPlaying => 'Playing';

  @override
  String get joinGameModeDropIn => 'Drop-in';

  @override
  String get joinGameAccessibilityOpen => 'Open';

  @override
  String get joinGameAccessibilityFull => 'Full';

  @override
  String get waitingRoomRoomNotFound => 'Game not found';

  @override
  String get waitingRoomRoomLocked => 'Game is locked';

  @override
  String get joinGameMaxPlayerLimitReached => 'Maximum player limit reached';

  @override
  String get joinGameInsufficientBalance =>
      'Insufficient balance to join this game';
}
