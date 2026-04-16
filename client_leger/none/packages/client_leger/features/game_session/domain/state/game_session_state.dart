import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_state.freezed.dart';

@freezed
sealed class GameSessionState with _$GameSessionState {
  const GameSessionState._();

  const factory GameSessionState.active({
    required String roomId,
    required String hostId,
    @Default(false) bool isCTF,
  }) = GameSessionActive;

  const factory GameSessionState.finished({
    required String roomId,
    required String winnerId,
    required String hostId,
    @Default(false) bool isCTF,
  }) = GameSessionFinished;

  @override
  String get hostId => switch (this) {
    GameSessionActive(:final hostId) => hostId,
    GameSessionFinished(:final hostId) => hostId,
  };

  @override
  bool get isCTF => switch (this) {
    GameSessionActive(:final isCTF) => isCTF,
    GameSessionFinished(:final isCTF) => isCTF,
  };
}
