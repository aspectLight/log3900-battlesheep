// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponseDto _$SignInResponseDtoFromJson(Map<String, dynamic> json) =>
    SignInResponseDto(
      sessionId: json['sessionId'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInResponseDtoToJson(SignInResponseDto instance) =>
    <String, dynamic>{'sessionId': instance.sessionId, 'user': instance.user};
