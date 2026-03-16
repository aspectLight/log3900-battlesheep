import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_sign_in_result.freezed.dart';

@freezed
class FirebaseSignInResult with _$FirebaseSignInResult {
  const factory FirebaseSignInResult({required String idToken}) =
      _FirebaseSignInResult;
}
