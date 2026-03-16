import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_data.freezed.dart';

@freezed
class GameSessionData with _$GameSessionData {
  const factory GameSessionData({
    required String roomId,
    required String gameId,
    required String socketId,
    @Default(false) bool isHost,
    required String gameName,
    required String gameDescription,
  }) = _GameSessionData;
}
