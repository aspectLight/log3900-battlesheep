import 'package:json_annotation/json_annotation.dart';

part 'firebase_auth_error_response_dto.g.dart';

@JsonSerializable()
class FirebaseAuthErrorResponseDto {
  final FirebaseAuthErrorDetailDto? error;

  const FirebaseAuthErrorResponseDto({this.error});

  factory FirebaseAuthErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthErrorResponseDtoFromJson(json);

  String? get errorMessage => error?.message;
}

@JsonSerializable()
class FirebaseAuthErrorDetailDto {
  final String? message;

  const FirebaseAuthErrorDetailDto({this.message});

  factory FirebaseAuthErrorDetailDto.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthErrorDetailDtoFromJson(json);
}

