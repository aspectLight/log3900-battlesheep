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
  String get createGameLastModifiedHeader => 'Last modified';

  @override
  String get createGameModeClassic => 'Classic';

  @override
  String get createGameModeCtf => 'Capture the flag';
}
