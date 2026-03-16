class ProfileStatisticsModel {
  final int classicGamesPlayed;
  final int ctfGamesPlayed;
  final int totalGamesWon;
  final int averagePlaytimePerGame;

  const ProfileStatisticsModel({
    required this.classicGamesPlayed,
    required this.ctfGamesPlayed,
    required this.totalGamesWon,
    required this.averagePlaytimePerGame,
  });
}

