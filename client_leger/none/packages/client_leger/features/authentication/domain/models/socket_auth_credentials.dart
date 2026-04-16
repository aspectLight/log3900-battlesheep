import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_auth_credentials.freezed.dart';

@freezed
class SocketAuthCredentialsModel with _$SocketAuthCredentialsModel {
  const factory SocketAuthCredentialsModel({
    required String token,
    required String sessionId,
  }) = _SocketAuthCredentialsModel;
}
