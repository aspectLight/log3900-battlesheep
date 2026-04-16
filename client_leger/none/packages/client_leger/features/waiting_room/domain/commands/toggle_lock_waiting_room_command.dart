import 'package:freezed_annotation/freezed_annotation.dart';

part 'toggle_lock_waiting_room_command.freezed.dart';

@freezed
class ToggleLockWaitingRoomCommand with _$ToggleLockWaitingRoomCommand {
  const factory ToggleLockWaitingRoomCommand({required String roomId}) =
      _ToggleLockWaitingRoomCommand;
}
