import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_player_model.dart';

part 'player_joined_event.freezed.dart';

@freezed
class PlayerJoinedEvent with _$PlayerJoinedEvent {
  const factory PlayerJoinedEvent({required WaitingRoomPlayerModel player}) =
      _PlayerJoinedEvent;
}
