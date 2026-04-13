// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'join_game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class JoinGameSessionLocalizationsFr extends JoinGameSessionLocalizations {
  JoinGameSessionLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get mainMenu => 'Menu Principal';

  @override
  String get ok => 'OK';

  @override
  String get joinGameTitle => 'Rejoindre une partie';

  @override
  String get joinGameSubtitle => 'Entrez le code de la partie à 4 chiffres';

  @override
  String get joinGameDescription =>
      'Vous pouvez trouver ce code dans la salle d\'attente de la partie';

  @override
  String get joinGameButton => 'Accéder à la salle d\'attente';

  @override
  String get joinGameFailed => 'Impossible de rejoindre la partie';

  @override
  String get waitingRoomRoomNotFound => 'Partie introuvable';

  @override
  String get waitingRoomRoomLocked => 'Partie verrouillée';

  @override
  String get joinGameMaxPlayerLimitReached =>
      'Nombre maximum de joueurs atteint';

  @override
  String get joinGameInsufficientBalance =>
      'Solde insuffisant pour rejoindre cette partie';
}
