// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'select_game_session_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SelectGameSessionLocalizationsFr extends SelectGameSessionLocalizations {
  SelectGameSessionLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get mainMenu => 'Page d\'accueil';

  @override
  String get createGame => 'Créer une partie';

  @override
  String get ok => 'OK';

  @override
  String get selectedGameHiddenOrDeleted =>
      'Le jeu sélectionné est caché ou supprimé.';

  @override
  String get createGamePreviewHeader => 'Aperçu';

  @override
  String get createGameNameHeader => 'Nom';

  @override
  String get createGameSizeHeader => 'Taille';

  @override
  String get createGameModeHeader => 'Mode';

  @override
  String get createGameLastModifiedHeader => 'Dernière modification';

  @override
  String get createGameModeClassic => 'Classique';

  @override
  String get createGameModeCtf => 'Capture du drapeau';

  @override
  String get createGameEntryFeeLabel => 'Frais d\'entrée';

  @override
  String get createGameEntryFeeHint => '0 = gratuit';

  @override
  String get createGameBalanceLabel => 'Votre solde';

  @override
  String get createGameInsufficientFundsTitle => 'Solde insuffisant';

  @override
  String get createGameInsufficientFundsMessage =>
      'Vous n\'avez pas assez de pièces pour ce montant. Réduisez les frais ou gagnez des pièces à la boutique.';

  @override
  String get noGames => 'Aucun jeu disponible.';
}
