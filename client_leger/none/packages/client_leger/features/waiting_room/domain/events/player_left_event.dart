import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_left_event.freezed.dart';

@freezed
class PlayerLeftEvent with _$PlayerLeftEvent {
  const factory PlayerLeftEvent({required String playerId}) = _PlayerLeftEvent;
}
