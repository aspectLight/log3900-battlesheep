import '../../../../core/app_transition/app_transition_bus.dart';
import '../../domain/models/character_creation_entry_mode.dart';
import '../../domain/commands/create_character_commands.dart';
import '../../core/app_events/character_creation_events.dart';
import '../../data/repositories/character_creation_repository.dart';

class CreateCharacterUseCase {
  CreateCharacterUseCase({
    required CharacterCreationRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
    required String roomCode,
    required CharacterCreationEntryMode entryMode,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       _roomCode = roomCode,
       _entryMode = entryMode;

  final CharacterCreationRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;
  final String _roomCode;
  final CharacterCreationEntryMode _entryMode;

  Future<void> execute(CreateCharacterCommand command) async {
    String roomCode = _roomCode;
    switch (_entryMode) {
      case CharacterCreationHostEntryMode(:final gameId):
        roomCode = await _repository.generateRoomCode();
        _repository.createWaitingRoom(
          command: CreateWaitingRoomCommand(
            roomCode: roomCode,
            gameId: gameId,
            host: command.player,
          ),
        );
      case CharacterCreationJoinEntryMode():
        _repository.submitCharacter(command);
    }
    _appTransitionEventBus.fire(
      CharacterCreationExitAppEvent.transitionToWaitingRoom(roomCode: roomCode),
    );
  }
}
