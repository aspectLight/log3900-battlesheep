// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseDto _$SignUpResponseDtoFromJson(Map<String, dynamic> json) =>
    SignUpResponseDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseDtoToJson(SignUpResponseDto instance) =>
    <String, dynamic>{'user': instance.user};
