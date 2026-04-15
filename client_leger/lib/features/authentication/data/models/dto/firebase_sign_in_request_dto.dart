import 'package:json_annotation/json_annotation.dart';

part 'firebase_sign_in_request_dto.g.dart';

@JsonSerializable()
class FirebaseSignInRequestDto {
  final String email;
  final String password;

  @JsonKey(name: 'returnSecureToken')
  final bool returnSecureToken;

  const FirebaseSignInRequestDto({
    required this.email,
    required this.password,
    this.returnSecureToken = true,
  });

  factory FirebaseSignInRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FirebaseSignInRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSignInRequestDtoToJson(this);
}
