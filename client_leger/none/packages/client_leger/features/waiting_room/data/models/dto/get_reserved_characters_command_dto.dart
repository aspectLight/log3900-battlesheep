import 'package:json_annotation/json_annotation.dart';

part 'get_reserved_characters_command_dto.g.dart';

@JsonSerializable()
class GetReservedCharactersCommandDto {
  final String roomId;

  const GetReservedCharactersCommandDto({required this.roomId});

  factory GetReservedCharactersCommandDto.fromJson(Map<String, dynamic> json) =>
      _$GetReservedCharactersCommandDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetReservedCharactersCommandDtoToJson(this);
}
