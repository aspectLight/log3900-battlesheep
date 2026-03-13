import 'package:json_annotation/json_annotation.dart';

part 'firebase_auth_response.g.dart';

@JsonSerializable()
class FirebaseAuthResponse {
  final String idToken;
  final String refreshToken;
  final String localId;

  const FirebaseAuthResponse({
    required this.idToken,
    required this.refreshToken,
    required this.localId,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseAuthResponseToJson(this);
}
