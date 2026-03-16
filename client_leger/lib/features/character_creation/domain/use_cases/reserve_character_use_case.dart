import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/reserve_character_failure.dart';
import '../../domain/commands/reserve_character_command.dart';
import '../../data/repositories/character_creation_repository.dart';

class ReserveCharacterUseCase {
  ReserveCharacterUseCase({
    required CharacterCreationRepository repository,
    required String roomCode,
    required String socketId,
  }) : _repository = repository,
       _roomCode = roomCode,
       _socketId = socketId;

  final CharacterCreationRepository _repository;
  final String _roomCode;
  final String _socketId;

  Future<Either<ReserveCharacterFailure, void>> execute(String characterId) {
    return _repository.reserveCharacter(
      ReserveCharacterCommand(
        roomId: _roomCode,
        chosenAvatar: characterId,
        playerId: _socketId,
      ),
    );
  }
}
