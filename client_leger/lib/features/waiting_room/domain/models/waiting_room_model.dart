import 'package:freezed_annotation/freezed_annotation.dart';

import 'waiting_room_player_model.dart';

part 'waiting_room_model.freezed.dart';

@freezed
class WaitingRoomModel with _$WaitingRoomModel {
  const factory WaitingRoomModel({
    required String roomId,
    required String hostId,
    required List<WaitingRoomPlayerModel> players,
    @Default(false) bool isLocked,
  }) = _WaitingRoomModel;

  factory WaitingRoomModel.initial({
    required String roomId,
    required String hostId,
  }) =>
      WaitingRoomModel(
        roomId: roomId,
        hostId: hostId,
        players: const [],
      );
}
