// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'statistics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class StatisticsLocalizationsFr extends StatisticsLocalizations {
  StatisticsLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get statisticsReturnHome => 'Page d\'accueil';

  @override
  String get statisticsPlayersTitle => 'Joueurs';

  @override
  String get statisticsPlayerName => 'Joueurs';

  @override
  String get statisticsCombats => 'Nombre de combats';

  @override
  String get statisticsEvasions => 'Nombre d\'évasions';

  @override
  String get statisticsVictories => 'Nombre de victoires';

  @override
  String get statisticsDefeats => 'Nombre de défaites';

  @override
  String get statisticsHealthLost => 'Points de vie perdus';

  @override
  String get statisticsDamage => 'Points de vie enlevés';

  @override
  String get statisticsItemsCollected => 'Nombre d\'objets différents ramassés';

  @override
  String get statisticsTilesVisited =>
      'Pourcentage de tuiles de terrain visitées';

  @override
  String get statisticsGlobalTitle => 'Global';

  @override
  String get statisticsRewardsTitle => 'Récompenses';

  @override
  String get statisticsDuration => 'Durée de la partie';

  @override
  String get statisticsTurns => 'Nombre de tours de jeu';

  @override
  String get statisticsTilesExplored =>
      'Pourcentage des tuiles de terrain visitées par au moins un joueur';

  @override
  String get statisticsDoorsToggled =>
      'Pourcentage des portes ayant été manipulées au moins une fois';

  @override
  String get statisticsFlags =>
      'Nombre de joueurs différents ayant détenu le drapeau';
}
