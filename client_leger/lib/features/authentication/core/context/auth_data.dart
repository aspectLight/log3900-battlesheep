import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_data.freezed.dart';

@freezed
class AuthData with _$AuthData {
  const factory AuthData({
    required String username,
    required String socketId,
  }) = _AuthData;
}
