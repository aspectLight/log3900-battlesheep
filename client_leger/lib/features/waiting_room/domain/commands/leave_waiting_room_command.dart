import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_waiting_room_command.freezed.dart';

@freezed
class LeaveWaitingRoomCommand with _$LeaveWaitingRoomCommand {
  const factory LeaveWaitingRoomCommand({required String roomId}) =
      _LeaveWaitingRoomCommand;
}
