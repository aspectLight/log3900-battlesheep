import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'sign_up_response_dto.g.dart';

@JsonSerializable()
class SignUpResponseDto {
  final UserDto user;

  const SignUpResponseDto({
    required this.user,
  });

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseDtoFromJson(json);
}

