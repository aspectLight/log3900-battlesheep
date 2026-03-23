import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_credentials.freezed.dart';

@freezed
class AuthCredentialsModel with _$AuthCredentialsModel {
  const factory AuthCredentialsModel({
    required String apiToken,
    required String apiSessionId,
  }) = _AuthCredentialsModel;
}

