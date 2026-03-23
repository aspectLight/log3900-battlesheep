import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/character.dart';
import '../../../../core/enums/dice_stat_choice.dart';
import '../../../../core/enums/virtual_player_type.dart';
import 'waiting_room_player_stats_model.dart';

part 'waiting_room_player_model.freezed.dart';

@freezed
sealed class WaitingRoomPlayerModel with _$WaitingRoomPlayerModel {
  const factory WaitingRoomPlayerModel.human({
    required String id,
    required String name,
    required Character character,
    required WaitingRoomPlayerStatsModel stats,
    String? avatarDisplayPath,
  }) = HumanWaitingRoomPlayerModel;

  const factory WaitingRoomPlayerModel.virtual({
    required String id,
    required String name,
    required Character character,
    required WaitingRoomPlayerStatsModel stats,
    required VirtualPlayerType virtualType,
    DiceStatChoice? d6Choice,
    DiceStatChoice? d4Choice,
    String? avatarDisplayPath,
  }) = VirtualWaitingRoomPlayerModel;
}
