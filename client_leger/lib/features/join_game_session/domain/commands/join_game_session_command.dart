import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_game_session_command.freezed.dart';

@freezed
class JoinGameSessionCommand with _$JoinGameSessionCommand {
  const factory JoinGameSessionCommand({
    required String roomCode,
    required String socketId,
  }) = _JoinGameSessionCommand;
}
