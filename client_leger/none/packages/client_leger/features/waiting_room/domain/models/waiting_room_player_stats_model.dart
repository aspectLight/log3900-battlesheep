import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/constants/waiting_room_stat_constants.dart';
import 'waiting_room_player_stat_value_model.dart';

part 'waiting_room_player_stats_model.freezed.dart';

@freezed
class WaitingRoomPlayerStatsModel with _$WaitingRoomPlayerStatsModel {
  const factory WaitingRoomPlayerStatsModel({
    @Default(
      WaitingRoomPlayerStatValueModel(
        value: WaitingRoomStatConstants.defaultWaitingRoomStatValue,
        maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
      ),
    )
    WaitingRoomPlayerStatValueModel health,
    @Default(
      WaitingRoomPlayerStatValueModel(
        value: WaitingRoomStatConstants.defaultWaitingRoomStatValue,
        maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
      ),
    )
    WaitingRoomPlayerStatValueModel speed,
    @Default(
      WaitingRoomPlayerStatValueModel(
        value: WaitingRoomStatConstants.defaultWaitingRoomStatValue,
        maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
      ),
    )
    WaitingRoomPlayerStatValueModel attack,
    @Default(
      WaitingRoomPlayerStatValueModel(
        value: WaitingRoomStatConstants.defaultWaitingRoomStatValue,
        maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
      ),
    )
    WaitingRoomPlayerStatValueModel defense,
  }) = _WaitingRoomPlayerStatsModel;
}
