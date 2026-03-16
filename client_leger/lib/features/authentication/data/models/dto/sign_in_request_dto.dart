import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_dto.g.dart';

@JsonSerializable()
class SignInRequestDto {
  final String token;

  const SignInRequestDto({
    required this.token,
  });

  factory SignInRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}

