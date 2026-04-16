// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessagePayloadDto _$SendMessagePayloadDtoFromJson(
  Map<String, dynamic> json,
) => SendMessagePayloadDto(
  username: json['username'] as String,
  message: json['message'] as String,
  avatarId: json['avatarId'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$SendMessagePayloadDtoToJson(
  SendMessagePayloadDto instance,
) => <String, dynamic>{
  'username': instance.username,
  'message': instance.message,
  if (instance.avatarId case final value?) 'avatarId': value,
  if (instance.avatarUrl case final value?) 'avatarUrl': value,
};
