import 'package:json_annotation/json_annotation.dart';

part 'send_message_payload_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class SendMessagePayloadDto {
  final String username;
  final String message;
  final String? avatarId;
  final String? avatarUrl;

  const SendMessagePayloadDto({
    required this.username,
    required this.message,
    this.avatarId,
    this.avatarUrl,
  });

  factory SendMessagePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessagePayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessagePayloadDtoToJson(this);
}
