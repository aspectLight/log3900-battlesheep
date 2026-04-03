import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/waiting_room_model.dart';

part 'waiting_room_entry_data.freezed.dart';

@freezed
sealed class WaitingRoomEntryData with _$WaitingRoomEntryData {
  const factory WaitingRoomEntryData.host({
    required String roomId,
    required String hostId,
    required String socketId,
    required String gameName,
    required String gameDescription,
    required int boardSize,
    required bool isCTF,
    @Default(false) bool friendsOnly,
  }) = WaitingRoomHostEntryData;

  const factory WaitingRoomEntryData.join({
    required String roomId,
    required String hostId,
    required String socketId,
    required String gameName,
    required String gameDescription,
    required WaitingRoomModel initialRoom,
  }) = WaitingRoomJoinEntryData;
}
