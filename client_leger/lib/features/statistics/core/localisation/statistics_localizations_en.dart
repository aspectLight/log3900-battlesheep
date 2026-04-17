// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'statistics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StatisticsLocalizationsEn extends StatisticsLocalizations {
  StatisticsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statisticsReturnHome => 'Home';

  @override
  String get statisticsPlayersTitle => 'Players';

  @override
  String get statisticsPlayerName => 'Players';

  @override
  String get statisticsCombats => 'Number of combats';

  @override
  String get statisticsEvasions => 'Number of evasions';

  @override
  String get statisticsVictories => 'Number of victories';

  @override
  String get statisticsDefeats => 'Number of defeats';

  @override
  String get statisticsHealthLost => 'Health points lost';

  @override
  String get statisticsDamage => 'Health points dealt';

  @override
  String get statisticsItemsCollected => 'Number of different items collected';

  @override
  String get statisticsTilesVisited => 'Percentage of terrain tiles visited';

  @override
  String get statisticsGlobalTitle => 'Global';

  @override
  String get statisticsRewardsTitle => 'Rewards';

  @override
  String get statisticsDuration => 'Game duration';

  @override
  String get statisticsTurns => 'Number of game turns';

  @override
  String get statisticsTilesExplored =>
      'Percentage of terrain tiles visited by at least one player';

  @override
  String get statisticsDoorsToggled =>
      'Percentage of doors toggled at least once';

  @override
  String get statisticsFlags => 'Number of different players who held the flag';

  @override
  String statisticsShareSocialBlurb(
    String result,
    int deaths,
    int combatPct,
    int tilePct,
  ) {
    return '🎮 Match result: $result!\n💀 Deaths: $deaths\n⚔️ Combats won: $combatPct%\n🗺️ Tiles visited: $tilePct%\n#EasternSolace #Jeux';
  }

  @override
  String get statisticsShareResultNounWin => 'victory';

  @override
  String get statisticsShareResultNounLoss => 'defeat';

  @override
  String get statisticsShareX => 'Share on X';

  @override
  String get statisticsShareBluesky => 'Share on Bluesky';

  @override
  String get statisticsShareSectionTitle => 'Share my results';

  @override
  String get statisticsSharePublishX => 'Post on X';

  @override
  String get statisticsSharePublishBluesky => 'Post on Bluesky';

  @override
  String get statisticsShareXHint =>
      'Sign in to X, then a draft with your stats opens — just post when ready.';

  @override
  String get statisticsShareBlueskyHint =>
      'Opens Bluesky with a ready draft (300 characters max). Sign in if needed, then post.';
}
