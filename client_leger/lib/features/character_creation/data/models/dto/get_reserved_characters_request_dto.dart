import 'package:json_annotation/json_annotation.dart';

part 'get_reserved_characters_request_dto.g.dart';

@JsonSerializable()
class GetReservedCharactersRequestDto {
  final String roomId;

  const GetReservedCharactersRequestDto({required this.roomId});

  factory GetReservedCharactersRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetReservedCharactersRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetReservedCharactersRequestDtoToJson(this);
}
