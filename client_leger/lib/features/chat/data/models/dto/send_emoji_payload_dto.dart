import 'package:json_annotation/json_annotation.dart';

part 'send_emoji_payload_dto.g.dart';

@JsonSerializable()
class SendEmojiPayloadDto {
  final String username;
  final String emoji;

  const SendEmojiPayloadDto({required this.username, required this.emoji});

  factory SendEmojiPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$SendEmojiPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendEmojiPayloadDtoToJson(this);
}
