import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_player_model.dart';

part 'create_waiting_room_command.freezed.dart';

@freezed
class CreateWaitingRoomCommand with _$CreateWaitingRoomCommand {
  const factory CreateWaitingRoomCommand({
    required String roomId,
    required String gameId,
    required WaitingRoomPlayerModel host,
    @Default(false) bool friendsOnly,
  }) = _CreateWaitingRoomCommand;
}
