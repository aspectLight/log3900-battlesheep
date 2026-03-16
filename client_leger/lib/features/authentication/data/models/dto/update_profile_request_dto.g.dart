// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequestDto _$UpdateProfileRequestDtoFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequestDto(
  username: json['username'] as String?,
  email: json['email'] as String?,
  avatarId: json['avatarId'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestDtoToJson(
  UpdateProfileRequestDto instance,
) => <String, dynamic>{
  if (instance.username case final value?) 'username': value,
  if (instance.email case final value?) 'email': value,
  if (instance.avatarId case final value?) 'avatarId': value,
};
