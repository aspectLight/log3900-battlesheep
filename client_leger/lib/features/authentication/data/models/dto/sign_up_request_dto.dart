import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class SignUpRequestDto {
  final String username;
  final String email;
  final String password;
  final String avatarId;
  final String? language;
  final String? theme;

  const SignUpRequestDto({
    required this.username,
    required this.email,
    required this.password,
    required this.avatarId,
    this.language,
    this.theme,
  });

  factory SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}
