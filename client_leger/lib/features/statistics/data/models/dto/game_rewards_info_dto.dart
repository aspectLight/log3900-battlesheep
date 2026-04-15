class PlayerRewardInfoDto {
  const PlayerRewardInfoDto({
    required this.name,
    required this.gain,
    required this.avatarName,
  });

  final String name;
  final int gain;
  final String avatarName;

  factory PlayerRewardInfoDto.fromJson(Map<String, dynamic> json) {
    return PlayerRewardInfoDto(
      name: json['name'] as String? ?? '',
      gain: json['gain'] as int? ?? 0,
      avatarName: json['avatarName'] as String? ?? '',
    );
  }
}

class GameRewardsInfoDto {
  const GameRewardsInfoDto({
    required this.rewards,
    required this.entryFee,
    required this.pool,
  });

  final List<PlayerRewardInfoDto> rewards;
  final int entryFee;
  final int pool;

  factory GameRewardsInfoDto.fromJson(Map<String, dynamic> json) {
    final rewardsRaw = json['rewards'];
    final rewards = rewardsRaw is List
        ? rewardsRaw
              .whereType<Map<String, dynamic>>()
              .map(PlayerRewardInfoDto.fromJson)
              .toList(growable: false)
        : const <PlayerRewardInfoDto>[];
    return GameRewardsInfoDto(
      rewards: rewards,
      entryFee: json['entryFee'] as int? ?? 0,
      pool: json['pool'] as int? ?? 0,
    );
  }

  factory GameRewardsInfoDto.fromSocketData(Map<String, dynamic> data) =>
      GameRewardsInfoDto.fromJson(data);
}
