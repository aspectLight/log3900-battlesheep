import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/services/socket_service.dart';
import '../../../game_session/core/context/drop_in_join_sync_holder.dart';
import '../../../join_game_session/core/exceptions/join_game_session_failure.dart';
import '../../core/exceptions/reserve_character_failure.dart';
import '../../../../core/helpers/replay_latest_broadcast_controller.dart';
import '../../domain/commands/get_reserved_characters_command.dart';
import '../../core/helpers/reserve_character_failure_mapper.dart';
import '../../domain/commands/create_character_commands.dart';
import '../../domain/commands/reserve_character_command.dart';
import '../../domain/events/character_creation_events.dart';
import '../../domain/result/drop_in_join_result.dart';
import '../models/dto/generate_room_code_response_dto.dart';
import '../models/dto/reserve_character_ack_dto.dart';
import '../models/dto/reserve_character_request_dto.dart';
import '../models/dto/update_character_reserved_payload_dto.dart';
import '../models/events/character_creation_socket_events.dart';
import '../models/extensions/create_character_command_to_dto_extensions.dart';
import '../models/extensions/get_reserved_characters_command_to_dto_extensions.dart';
import '../models/extensions/update_character_reserved_payload_dto_extensions.dart';

class CharacterCreationSocket {
  CharacterCreationSocket({
    required SocketService socketService,
    required DropInJoinSyncHolder dropInJoinSyncHolder,
  })  : _socketService = socketService,
        _dropInJoinSyncHolder = dropInJoinSyncHolder {
    _setupListeners();
  }

  final SocketService _socketService;
  final DropInJoinSyncHolder _dropInJoinSyncHolder;

  // Cancelled in dispose().
  // ignore: cancel_subscriptions
  StreamSubscription<Object?>? _updateCharacterReservedSub;

  final _reservedCharactersController =
      ReplayLatestBroadcastController<UpdateCharacterReservedPayloadDto>();
  int _reservedUpdateSeq = 0;

  Stream<UpdateCharacterReservedPayloadDto> get reservedCharactersPayloadStream =>
      _reservedCharactersController.stream;

  Stream<void> get roomLockedStream => _socketService
      .on(CharacterCreationSocketEvents.waitingRoomLocked)
      .map((_) {});

  void _setupListeners() {
    _updateCharacterReservedSub = _socketService
        .on(CharacterCreationSocketEvents.updateAvatarReserved)
        .listen((data) {
          final payload = UpdateCharacterReservedPayloadDto.fromObject(data);
          if (!_reservedCharactersController.isClosed) {
            _reservedUpdateSeq++;
            _reservedCharactersController.add(payload);
          }
        });
  }

  void _stopListening() {
    final updateSub = _updateCharacterReservedSub;
    if (updateSub != null) {
      unawaited(updateSub.cancel());
      _updateCharacterReservedSub = null;
    }
    _socketService.off(CharacterCreationSocketEvents.updateAvatarReserved);
  }

  void requestReservedCharacters(GetReservedCharactersCommand command) {
    final request = command.toGetReservedCharactersRequestDto();
    _socketService.emit(
      CharacterCreationSocketEvents.getReservedAvatars,
      request.toJson(),
    );
  }

  Future<List<ReservedCharacterEvent>> fetchReservedCharacters(
    GetReservedCharactersCommand command,
  ) {
    final beforeSeq = _reservedUpdateSeq;
    requestReservedCharacters(command);

    return reservedCharactersPayloadStream
        .skipWhile((_) => _reservedUpdateSeq == beforeSeq)
        .map((payload) => payload.toReservedCharacterEventList())
        .first;
  }

  Future<String> generateRoomCode() async {
    final responseFuture = _socketService
        .on<Map<String, dynamic>>(
          CharacterCreationSocketEvents.generateCodeResponse,
        )
        .first;
    _socketService.emit(CharacterCreationSocketEvents.generateCode);
    final response = await responseFuture;
    final dto = GenerateRoomCodeResponseDto.fromJson(response);
    return dto.code;
  }

  Future<Either<ReserveCharacterFailure, void>> reserveCharacter(
    ReserveCharacterCommand command,
  ) {
    final request = ReserveCharacterRequestDto(
      roomId: command.roomId,
      chosenAvatar: command.chosenAvatar,
      playerId: command.playerId,
    );
    return _socketService.emitWithAckEither<ReserveCharacterFailure, void>(
      CharacterCreationSocketEvents.reserveAvatar,
      request.toJson(),
      (data) {
        if (data == null) return right(null);
        if (data is! Map<String, dynamic>) return right(null);
        final dto = ReserveCharacterAckDto.fromJson(data);
        if (dto.success) return right(null);
        return left(reserveCharacterFailureFromServerMessage(dto.error));
      },
    );
  }

  void submitCharacter(CreateCharacterCommand command) {
    final request = command.toCreatePlayerRequestDto();
    _socketService.emit(
      CharacterCreationSocketEvents.createPlayer,
      request.toJson(),
    );
  }

  Future<Either<JoinGameSessionFailure, DropInJoinResult>> joinGameRoom(
    CreateCharacterCommand command,
  ) async {
    _dropInJoinSyncHolder.clear();
    final request = command.toCreatePlayerRequestDto();
    final responseFuture = _socketService
        .on<Object?>(CharacterCreationSocketEvents.joinGameRoomResponse)
        .first;
    final raw = await _socketService.emitWithAck<Object?>(
      CharacterCreationSocketEvents.joinGameRoom,
      request.toJson(),
    );
    if (raw is! Map<String, dynamic>) {
      return left(
        const UnknownJoinGameSessionFailure('Invalid join game room response'),
      );
    }
    final success = raw['success'] as bool? ?? false;
    if (!success) {
      final message = raw['error'] as String? ?? 'Unknown error';
      return left(_mapJoinGameRoomError(message));
    }
    final response = await responseFuture.timeout(
      const Duration(seconds: 30),
      onTimeout: () => null,
    );
    if (response == null) {
      return left(
        const UnknownJoinGameSessionFailure('Missing joinGameRoomResponse'),
      );
    }
    if (response is! Map<String, dynamic>) {
      return left(
        const UnknownJoinGameSessionFailure('Invalid joinGameRoomResponse'),
      );
    }
    final ok = response['success'] as bool? ?? false;
    if (!ok) {
      final message = response['error'] as String? ?? 'Unknown error';
      return left(_mapJoinGameRoomError(message));
    }
    final gameRoom = response['gameRoom'];
    if (gameRoom is! Map<String, dynamic>) {
      return left(
        const UnknownJoinGameSessionFailure('Invalid game room payload'),
      );
    }
    final currentBoardRaw = response['currentBoard'];
    final currentBoard = currentBoardRaw is Map<String, dynamic>
        ? currentBoardRaw
        : null;
    final roomId = gameRoom['roomId'] as String? ?? command.roomId;
    final gameId = gameRoom['gameId'] as String? ?? '';
    if (gameId.isEmpty) {
      return left(
        const UnknownJoinGameSessionFailure('Missing game id in response'),
      );
    }
    final currentPlayerId = response['currentPlayerId'] as String?;
    final turnTimeRemaining = (response['turnTimeRemaining'] as num?)?.toInt();
    final turnCountdownPhase = response['turnCountdownPhase'] as String?;
    _dropInJoinSyncHolder.setFromJoinResponse(
      gameRoom,
      currentBoard,
      currentPlayerId,
      turnTimeRemaining: turnTimeRemaining,
      turnCountdownPhase: turnCountdownPhase,
    );
    return right(DropInJoinResult(roomId: roomId, gameId: gameId));
  }

  JoinGameSessionFailure _mapJoinGameRoomError(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('existe pas') ||
        normalized.contains('introuvable') ||
        normalized.contains('not found')) {
      return const RoomNotFoundJoinGameSessionFailure();
    }
    if (normalized.contains('verrouill')) {
      return const RoomLockedJoinGameSessionFailure();
    }
    if (normalized.contains('maximum') ||
        normalized.contains('nombre maximum') ||
        normalized.contains('limit')) {
      return const MaxPlayerLimitReachedJoinGameSessionFailure();
    }
    return UnknownJoinGameSessionFailure(message);
  }

  void createWaitingRoom({required CreateWaitingRoomCommand command}) {
    final request = command.toCreateWaitingRoomRequestDto();
    _socketService.emit(
      CharacterCreationSocketEvents.createWaitingRoom,
      request.toJson(),
    );
  }

  void dispose() {
    _stopListening();
    if (!_reservedCharactersController.isClosed) {
      unawaited(_reservedCharactersController.close());
    }
  }
}
