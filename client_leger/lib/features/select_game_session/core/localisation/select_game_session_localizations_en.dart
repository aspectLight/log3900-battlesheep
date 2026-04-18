// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'select_game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SelectGameSessionLocalizationsEn extends SelectGameSessionLocalizations {
  SelectGameSessionLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get mainMenu => 'Home';

  @override
  String get createGame => 'Create Game';

  @override
  String get ok => 'OK';

  @override
  String get selectedGameHiddenOrDeleted =>
      'The selected game is hidden or deleted.';

  @override
  String get createGamePreviewHeader => 'Preview';

  @override
  String get createGameNameHeader => 'Name';

  @override
  String get createGameSizeHeader => 'Size';

  @override
  String get createGameModeHeader => 'Mode';

  @override
  String get createGameOwnerHeader => 'Owner';

  @override
  String get createGameLastModifiedHeader => 'Last modified';

  @override
  String get createGameModeClassic => 'Classic';

  @override
  String get createGameModeCtf => 'Capture the flag';

  @override
  String get createGameAccessibilityLabel => 'Accessibility';

  @override
  String get createGameFriendsOnlyLabel => 'Friends only';

  @override
  String get createGameEntryFeeSectionLabel => 'Entry price';

  @override
  String get createGameEntryFeeLabel => 'Entry fee';

  @override
  String get createGameEntryFeeHint => '0 = free';

  @override
  String get createGameBalanceLabel => 'Your balance';

  @override
  String get createGameInsufficientFundsTitle => 'Insufficient balance';

  @override
  String get createGameInsufficientFundsMessage =>
      'You do not have enough coins to set this entry fee. Lower the fee or earn coins in the shop.';

  @override
  String get noGames => 'No games available.';
}
