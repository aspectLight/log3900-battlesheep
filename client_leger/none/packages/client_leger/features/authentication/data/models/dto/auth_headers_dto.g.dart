// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_headers_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthHeadersDto _$AuthHeadersDtoFromJson(Map<String, dynamic> json) =>
    AuthHeadersDto(
      authorization: json['Authorization'] as String,
      sessionId: json['x-session-id'] as String,
    );

Map<String, dynamic> _$AuthHeadersDtoToJson(AuthHeadersDto instance) =>
    <String, dynamic>{
      'Authorization': instance.authorization,
      'x-session-id': instance.sessionId,
    };
