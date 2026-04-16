import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../game_session/core/app_events/game_session_events.dart';
import '../../../join_game_session/data/services/join_game_session_socket.dart';
import '../../../join_game_session/domain/commands/join_game_session_command.dart';
import '../../core/app_events/character_creation_events.dart';
import '../../data/repositories/character_creation_repository.dart';
import '../../domain/commands/create_character_commands.dart';
import '../../domain/models/character_creation_entry_mode.dart';

class CreateCharacterUseCase {
  CreateCharacterUseCase({
    required CharacterCreationRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
    required JoinGameSessionSocket joinGameSessionSocket,
    required String roomCode,
    required CharacterCreationEntryMode entryMode,
    required String socketId,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       _joinGameSessionSocket = joinGameSessionSocket,
       _roomCode = roomCode,
       _entryMode = entryMode,
       _socketId = socketId;

  final CharacterCreationRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;
  final JoinGameSessionSocket _joinGameSessionSocket;
  final String _roomCode;
  final CharacterCreationEntryMode _entryMode;
  final String _socketId;

  Future<void> execute(CreateCharacterCommand command) async {
    String roomCode = _roomCode;
    switch (_entryMode) {
      case CharacterCreationHostEntryMode(
        :final gameId,
        :final entryFee,
        :final friendsOnly,
      ):
        roomCode = await _repository.generateRoomCode();
        _repository.createWaitingRoom(
          command: CreateWaitingRoomCommand(
            roomCode: roomCode,
            gameId: gameId,
            host: command.player,
            entryFee: entryFee,
            friendsOnly: friendsOnly,
          ),
        );
      case CharacterCreationJoinEntryMode():
        if (_entryMode.isDropIn) {
          final dropInResult = await _repository.joinGameRoom(command);
          dropInResult.match(
            (failure) => throw failure,
            (result) => _appTransitionEventBus.fire(
              GameSessionEntryAppEvent.startRequested(
                roomId: result.roomId,
                gameId: result.gameId,
                socketId: _socketId,
                gameName: '',
                gameDescription: '',
              ),
            ),
          );
          return;
        }
        final joinResult = await _joinGameSessionSocket.joinRoom(
          JoinGameSessionCommand(roomCode: _roomCode, socketId: _socketId),
        );
        joinResult.match((f) => throw f, (_) {});
        _repository.submitCharacter(command);
    }
    _appTransitionEventBus.fire(
      CharacterCreationExitAppEvent.transitionToWaitingRoom(roomCode: roomCode),
    );
  }
}
