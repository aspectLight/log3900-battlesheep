import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'sign_in_response_dto.g.dart';

@JsonSerializable()
class SignInResponseDto {
  final String sessionId;
  final UserDto user;

  const SignInResponseDto({required this.sessionId, required this.user});

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseDtoToJson(this);
}
