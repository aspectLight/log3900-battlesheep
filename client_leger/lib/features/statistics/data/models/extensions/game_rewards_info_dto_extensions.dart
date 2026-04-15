import '../../../domain/models/game_rewards_info.dart';
import '../dto/game_rewards_info_dto.dart';

extension PlayerRewardInfoDtoToEntity on PlayerRewardInfoDto {
  PlayerRewardInfo toEntity() => PlayerRewardInfo(
    playerName: name,
    coinsEarned: gain,
    avatarName: avatarName,
  );
}

extension GameRewardsInfoDtoToEntity on GameRewardsInfoDto {
  GameRewardsInfo toEntity() => GameRewardsInfo(
    rewards: rewards.map((reward) => reward.toEntity()).toList(growable: false),
    entryFee: entryFee,
    pool: pool,
  );
}
