import 'package:json_annotation/json_annotation.dart';

part 'send_message_payload_dto.g.dart';

@JsonSerializable()
class SendMessagePayloadDto {
  final String username;
  final String message;

  const SendMessagePayloadDto({
    required this.username,
    required this.message,
  });

  factory SendMessagePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessagePayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessagePayloadDtoToJson(this);
}
