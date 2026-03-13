import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_player_model.dart';

part 'kick_player_command.freezed.dart';

@freezed
class KickPlayerCommand with _$KickPlayerCommand {
  const factory KickPlayerCommand({
    required String roomId,
    required WaitingRoomPlayerModel player,
  }) = _KickPlayerCommand;
}
