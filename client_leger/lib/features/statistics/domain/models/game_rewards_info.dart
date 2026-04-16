class PlayerRewardInfo {
  const PlayerRewardInfo({
    required this.playerName,
    required this.coinsEarned,
    required this.avatarName,
  });

  final String playerName;
  final int coinsEarned;
  final String avatarName;
}

class GameRewardsInfo {
  const GameRewardsInfo({
    required this.rewards,
    required this.entryFee,
    required this.pool,
  });

  static const empty = GameRewardsInfo(
    rewards: <PlayerRewardInfo>[],
    entryFee: 0,
    pool: 0,
  );

  final List<PlayerRewardInfo> rewards;
  final int entryFee;
  final int pool;
}
