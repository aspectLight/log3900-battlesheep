import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_player_model.dart';

part 'add_virtual_player_command.freezed.dart';

@freezed
class AddVirtualPlayerCommand with _$AddVirtualPlayerCommand {
  const factory AddVirtualPlayerCommand({
    required String roomId,
    required WaitingRoomPlayerModel player,
  }) = _AddVirtualPlayerCommand;
}
