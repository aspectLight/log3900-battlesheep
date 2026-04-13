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
  String get joinGameNoRooms => 'Aucune partie disponible';

  @override
  String get joinGameRoomListPreview => 'Prévisualisation';

  @override
  String get joinGameRoomListPlayers => 'Joueurs';

  @override
  String get joinGameRoomListSize => 'Taille';

  @override
  String get joinGameRoomListStatus => 'Statut';

  @override
  String get joinGameRoomListMode => 'Mode';

  @override
  String get joinGameRoomListAccessibility => 'Accessibilité';

  @override
  String get joinGameRoomListCode => 'Code';

  @override
  String get joinGameStatusWaiting => 'En attente';

  @override
  String get joinGameStatusPlaying => 'En cours';

  @override
  String get joinGameModeDropIn => 'Drop-in';

  @override
  String get joinGameAccessibilityOpen => 'Ouverte';

  @override
  String get joinGameAccessibilityFull => 'Complète';

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
