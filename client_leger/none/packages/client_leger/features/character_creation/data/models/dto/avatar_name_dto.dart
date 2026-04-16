import 'package:json_annotation/json_annotation.dart';

part 'avatar_name_dto.g.dart';

@JsonSerializable()
class AvatarNameDto {
  final String name;

  const AvatarNameDto({required this.name});

  factory AvatarNameDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarNameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarNameDtoToJson(this);
}
