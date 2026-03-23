// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAuthResponse _$FirebaseAuthResponseFromJson(
  Map<String, dynamic> json,
) => FirebaseAuthResponse(
  idToken: json['idToken'] as String,
  refreshToken: json['refreshToken'] as String,
  localId: json['localId'] as String,
);

Map<String, dynamic> _$FirebaseAuthResponseToJson(
  FirebaseAuthResponse instance,
) => <String, dynamic>{
  'idToken': instance.idToken,
  'refreshToken': instance.refreshToken,
  'localId': instance.localId,
};
