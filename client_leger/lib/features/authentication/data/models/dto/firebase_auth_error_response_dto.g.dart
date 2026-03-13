// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_error_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAuthErrorResponseDto _$FirebaseAuthErrorResponseDtoFromJson(
  Map<String, dynamic> json,
) => FirebaseAuthErrorResponseDto(
  error: json['error'] == null
      ? null
      : FirebaseAuthErrorDetailDto.fromJson(
          json['error'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FirebaseAuthErrorResponseDtoToJson(
  FirebaseAuthErrorResponseDto instance,
) => <String, dynamic>{'error': instance.error};

FirebaseAuthErrorDetailDto _$FirebaseAuthErrorDetailDtoFromJson(
  Map<String, dynamic> json,
) => FirebaseAuthErrorDetailDto(message: json['message'] as String?);

Map<String, dynamic> _$FirebaseAuthErrorDetailDtoToJson(
  FirebaseAuthErrorDetailDto instance,
) => <String, dynamic>{'message': instance.message};
