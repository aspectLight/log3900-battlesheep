import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_player_model.dart';

part 'player_created_event.freezed.dart';

@freezed
class PlayerCreatedEvent with _$PlayerCreatedEvent {
  const factory PlayerCreatedEvent({
    required List<WaitingRoomPlayerModel> players,
  }) = _PlayerCreatedEvent;
}
