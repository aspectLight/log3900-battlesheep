// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_emoji_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendEmojiPayloadDto _$SendEmojiPayloadDtoFromJson(Map<String, dynamic> json) =>
    SendEmojiPayloadDto(
      username: json['username'] as String,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$SendEmojiPayloadDtoToJson(
  SendEmojiPayloadDto instance,
) => <String, dynamic>{'username': instance.username, 'emoji': instance.emoji};
