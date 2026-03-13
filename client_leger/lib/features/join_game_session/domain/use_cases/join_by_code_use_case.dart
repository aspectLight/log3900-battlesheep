import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/join_game_session_failure.dart';
import '../../data/repositories/join_game_session_repository.dart';
import '../commands/join_game_session_command.dart';
import '../result/join_room_result.dart';

class JoinByCodeUseCase {
  JoinByCodeUseCase({required JoinGameSessionRepository repository})
    : _repository = repository;

  final JoinGameSessionRepository _repository;

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> execute(
    JoinGameSessionCommand command,
  ) {
    return _repository.join(command);
  }
}
