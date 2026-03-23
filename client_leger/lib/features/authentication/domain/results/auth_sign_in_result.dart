import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/user.dart';

part 'auth_sign_in_result.freezed.dart';

@freezed
class AuthSignInResult with _$AuthSignInResult {
  const factory AuthSignInResult({
    required UserModel user,
    required String apiToken,
    required String apiSessionId,
  }) = _AuthSignInResult;
}
