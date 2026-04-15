import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateProfileRequestDto {
  final String? username;
  final String? email;
  final String? avatarId;

  const UpdateProfileRequestDto({this.username, this.email, this.avatarId});

  factory UpdateProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}
