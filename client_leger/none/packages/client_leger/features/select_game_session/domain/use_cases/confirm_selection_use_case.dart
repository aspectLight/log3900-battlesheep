import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/select_game_session_failure.dart';
import '../../data/repositories/select_game_session_repository.dart';
import '../commands/select_game_session_commands.dart';
import '../models/game_info_model.dart';

class ConfirmSelectionUseCase {
  final SelectGameSessionRepository _repository;

  ConfirmSelectionUseCase({required SelectGameSessionRepository repository})
    : _repository = repository;

  TaskEither<SelectGameSessionFailure, GameModelInfo> execute(
    ConfirmSelectionCommand command,
  ) {
    return _repository.refreshGame(command.selectedGameId);
  }
}
