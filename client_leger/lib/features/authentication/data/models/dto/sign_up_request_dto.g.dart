// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestDto _$SignUpRequestDtoFromJson(Map<String, dynamic> json) =>
    SignUpRequestDto(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      avatarId: json['avatarId'] as String,
      language: json['language'] as String?,
      theme: json['theme'] as String?,
    );

Map<String, dynamic> _$SignUpRequestDtoToJson(SignUpRequestDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'avatarId': instance.avatarId,
      if (instance.language case final value?) 'language': value,
      if (instance.theme case final value?) 'theme': value,
    };
