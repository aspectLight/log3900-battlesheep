import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String id;
  final String username;
  final String email;
  final String avatarId;

  final Map<String, dynamic> preferences;

  const ProfileDto({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarId,
    this.preferences = const {},
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
  final Map<String, dynamic>? preferences;

  const ProfileUpdateRequestDto({
    this.username,
    this.email,
    this.avatarId,
    this.preferences,
  });

  factory ProfileUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateRequestDtoToJson(this);
}


