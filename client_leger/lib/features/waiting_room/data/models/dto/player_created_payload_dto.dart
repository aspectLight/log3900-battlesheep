import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_dto.dart';

part 'player_created_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerCreatedPayloadDto {
  final List<WaitingRoomPlayerDto> players;

  const PlayerCreatedPayloadDto({required this.players});

  factory PlayerCreatedPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerCreatedPayloadDtoFromJson(json);

  factory PlayerCreatedPayloadDto.fromList(List<dynamic> data) =>
      PlayerCreatedPayloadDto(
        players: data
            .map(
              (e) =>
                  WaitingRoomPlayerDto.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => _$PlayerCreatedPayloadDtoToJson(this);
}
