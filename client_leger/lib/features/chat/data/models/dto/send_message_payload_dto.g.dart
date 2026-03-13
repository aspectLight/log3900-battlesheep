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
);

Map<String, dynamic> _$SendMessagePayloadDtoToJson(
  SendMessagePayloadDto instance,
) => <String, dynamic>{
  'username': instance.username,
  'message': instance.message,
};
