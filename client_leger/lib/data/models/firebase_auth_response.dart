class FirebaseAuthResponse {
  final String idToken;
  final String refreshToken;
  final String localId;

  const FirebaseAuthResponse({
    required this.idToken,
    required this.refreshToken,
    required this.localId,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) {
    return FirebaseAuthResponse(
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      localId: json['localId'] as String,
    );
  }
}
