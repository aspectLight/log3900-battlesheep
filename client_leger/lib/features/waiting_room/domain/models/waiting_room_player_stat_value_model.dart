import 'package:freezed_annotation/freezed_annotation.dart';

part 'waiting_room_player_stat_value_model.freezed.dart';

@freezed
class WaitingRoomPlayerStatValueModel with _$WaitingRoomPlayerStatValueModel {
  const factory WaitingRoomPlayerStatValueModel({
    required int value,
    required int maxValue,
  }) = _WaitingRoomPlayerStatValueModel;
}
