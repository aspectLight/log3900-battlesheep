import 'package:json_annotation/json_annotation.dart';

part 'join_room_request_dto.g.dart';

@JsonSerializable()
class JoinRoomRequestDto {
  final String roomCode;
  const JoinRoomRequestDto({required this.roomCode});

  factory JoinRoomRequestDto.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JoinRoomRequestDtoToJson(this);
}
