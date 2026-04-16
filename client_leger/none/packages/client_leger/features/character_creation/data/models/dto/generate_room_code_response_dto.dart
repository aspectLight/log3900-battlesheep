import 'package:json_annotation/json_annotation.dart';

part 'generate_room_code_response_dto.g.dart';

@JsonSerializable()
class GenerateRoomCodeResponseDto {
  const GenerateRoomCodeResponseDto({required this.code});

  final String code;

  factory GenerateRoomCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GenerateRoomCodeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateRoomCodeResponseDtoToJson(this);
}
