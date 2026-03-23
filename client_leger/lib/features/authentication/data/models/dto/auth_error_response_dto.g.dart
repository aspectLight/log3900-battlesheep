// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthErrorResponseDto _$AuthErrorResponseDtoFromJson(
  Map<String, dynamic> json,
) => AuthErrorResponseDto(
  messages: AuthErrorResponseDto._messagesFromJson(json['message']),
);

Map<String, dynamic> _$AuthErrorResponseDtoToJson(
  AuthErrorResponseDto instance,
) => <String, dynamic>{'message': instance.messages};
