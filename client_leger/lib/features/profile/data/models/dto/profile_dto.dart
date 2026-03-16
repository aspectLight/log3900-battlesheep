import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String id;
  final String username;
  final String email;
  final String avatarId;

  const ProfileDto({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarId,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ProfileUpdateRequestDto {
  final String? username;
  final String? email;
  final String? avatarId;

  const ProfileUpdateRequestDto({
    this.username,
    this.email,
    this.avatarId,
  });

  factory ProfileUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateRequestDtoToJson(this);
}


