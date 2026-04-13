// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  avatarId: json['avatarId'] as String,
  theme: json['theme'] as String? ?? 'default',
  language: json['language'] as String? ?? 'fr',
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'avatarId': instance.avatarId,
      'theme': instance.theme,
      'language': instance.language,
      'preferences': instance.preferences,
    };

ProfileUpdateRequestDto _$ProfileUpdateRequestDtoFromJson(
  Map<String, dynamic> json,
) => ProfileUpdateRequestDto(
  username: json['username'] as String?,
  email: json['email'] as String?,
  avatarId: json['avatarId'] as String?,
  theme: json['theme'] as String?,
  language: json['language'] as String?,
  preferences: json['preferences'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ProfileUpdateRequestDtoToJson(
  ProfileUpdateRequestDto instance,
) => <String, dynamic>{
  if (instance.username case final value?) 'username': value,
  if (instance.email case final value?) 'email': value,
  if (instance.avatarId case final value?) 'avatarId': value,
  if (instance.theme case final value?) 'theme': value,
  if (instance.language case final value?) 'language': value,
  if (instance.preferences case final value?) 'preferences': value,
};
