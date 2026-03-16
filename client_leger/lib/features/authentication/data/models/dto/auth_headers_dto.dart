import 'package:json_annotation/json_annotation.dart';

part 'auth_headers_dto.g.dart';

@JsonSerializable()
class AuthHeadersDto {
  @JsonKey(name: 'Authorization')
  final String authorization;

  @JsonKey(name: 'x-session-id')
  final String sessionId;

  const AuthHeadersDto({
    required this.authorization,
    required this.sessionId,
  });

  factory AuthHeadersDto.create({
    required String apiToken,
    required String apiSessionId,
  }) =>
      AuthHeadersDto(
        authorization: 'Bearer $apiToken',
        sessionId: apiSessionId,
      );

  factory AuthHeadersDto.fromJson(Map<String, dynamic> json) =>
      _$AuthHeadersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthHeadersDtoToJson(this);
}

