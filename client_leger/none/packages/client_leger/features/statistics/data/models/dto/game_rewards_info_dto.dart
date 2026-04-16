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
      gain: (json['gain'] as num?)?.toInt() ?? 0,
      avatarName: json['avatarName']?.toString() ?? '',
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
    final rewards = <PlayerRewardInfoDto>[];
    if (rewardsRaw is List) {
      for (final item in rewardsRaw) {
        if (item is Map<String, dynamic>) {
          rewards.add(PlayerRewardInfoDto.fromJson(item));
        } else if (item is Map) {
          rewards.add(PlayerRewardInfoDto.fromJson(
            Map<String, dynamic>.from(item),
          ));
        }
      }
    }
    return GameRewardsInfoDto(
      rewards: rewards,
      entryFee: (json['entryFee'] as num?)?.toInt() ?? 0,
      pool: (json['pool'] as num?)?.toInt() ?? 0,
    );
  }

  factory GameRewardsInfoDto.fromSocketData(Map<String, dynamic> data) =>
      GameRewardsInfoDto.fromJson(data);
}
