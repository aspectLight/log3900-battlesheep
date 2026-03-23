// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_sign_in_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseSignInRequestDto _$FirebaseSignInRequestDtoFromJson(
  Map<String, dynamic> json,
) => FirebaseSignInRequestDto(
  email: json['email'] as String,
  password: json['password'] as String,
  returnSecureToken: json['returnSecureToken'] as bool? ?? true,
);

Map<String, dynamic> _$FirebaseSignInRequestDtoToJson(
  FirebaseSignInRequestDto instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'returnSecureToken': instance.returnSecureToken,
};
