import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/models/lobby_room_model.dart';
import '../../../../core/services/socket_service.dart';
import '../../core/exceptions/join_game_session_failure.dart';
import '../../domain/commands/join_game_session_command.dart';
import '../../domain/models/available_room_model.dart';
import '../../domain/result/join_room_result.dart';
import '../../../select_game_session/data/models/dto/game_summary_dto.dart';
import '../../../select_game_session/data/models/extensions/selectable_game_dto_extensions.dart';
import '../../../select_game_session/domain/models/game_info_model.dart';
import '../models/dto/join_room_response_dto.dart';
import '../models/extensions/join_room_response_dto_extensions.dart';
import '../models/events/join_game_session_socket_events.dart';

class JoinGameSessionSocket {
  JoinGameSessionSocket({required SocketService socketService})
    : _socketService = socketService;

  final SocketService _socketService;

  static const Duration _joinResponseTimeout = Duration(seconds: 25);
  static const Duration _availableRoomsTimeout = Duration(seconds: 20);

  Future<void>? _joinRoomSerial;
  Future<void>? _getRoomsSerial;

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> joinRoom(
    JoinGameSessionCommand command,
  ) async {
    while (_joinRoomSerial != null) {
      try {
        await _joinRoomSerial;
      } on Exception {
        // Ignore: previous join failed; allow next attempt.
      }
    }
    final serialDone = Completer<void>();
    _joinRoomSerial = serialDone.future;
    try {
      return await _joinRoomImpl(command);
    } on TimeoutException {
      return left(
        const UnknownJoinGameSessionFailure(
          'Délai dépassé en attendant la réponse du serveur (join).',
        ),
      );
    } finally {
      _joinRoomSerial = null;
      if (!serialDone.isCompleted) serialDone.complete();
    }
  }

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> _joinRoomImpl(
    JoinGameSessionCommand command,
  ) async {
    final roomCode = command.roomCode;
    final socketId = command.socketId;
    final responseFuture = _socketService
        .on<Object?>(JoinGameSessionSocketEvents.joinRoomResponse)
        .first
        .timeout(_joinResponseTimeout);
    _socketService.emit<String>(
      JoinGameSessionSocketEvents.joinWaitingRoom,
      roomCode,
    );
    final data = await responseFuture;
    final dto = data == null
        ? const JoinRoomResponseDto(success: false)
        : JoinRoomResponseDto.fromJson(data as Map<String, dynamic>);
    if (!dto.success) return left(dto.toFailure());
    final room = dto.room;
    if (room == null) {
      return left(
        const UnknownJoinGameSessionFailure(
          'Invalid join response: room missing',
        ),
      );
    }
    return right(
      JoinRoomResult(
        roomCode: roomCode,
        socketId: socketId,
        hostId: room.hostId,
        initialRoom: room.toLobbyRoomModel(),
      ),
    );
  }

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> joinOrDropIn(
    JoinGameSessionCommand command,
  ) async {
    final waitingRoomJoin = await joinRoom(command);
    return switch (waitingRoomJoin) {
      Right() => waitingRoomJoin,
      Left(value: final failure)
          when failure is! RoomNotFoundJoinGameSessionFailure &&
              failure is! RoomLockedJoinGameSessionFailure =>
        waitingRoomJoin,
      Left() => _tryResolveDropIn(command),
    };
  }

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> _tryResolveDropIn(
    JoinGameSessionCommand command,
  ) async {
    final rooms = await getAvailableRooms();
    final enteredCode = _normalizeRoomCode(command.roomCode);
    AvailableRoomModel? room;
    for (final candidate in rooms) {
      final canDropIn =
          _normalizeRoomCode(candidate.roomId) == enteredCode &&
          candidate.status == 'playing' &&
          candidate.dropInDropOut &&
          candidate.playerCount < candidate.maxPlayers;
      if (canDropIn) {
        room = candidate;
        break;
      }
    }
    if (room == null) {
      return left(const RoomNotFoundJoinGameSessionFailure());
    }
    return right(
      JoinRoomResult(
        roomCode: room.roomId,
        socketId: command.socketId,
        hostId: '',
        initialRoom: LobbyRoomModel(
          roomId: room.roomId,
          hostId: '',
          players: const [],
          isLocked: false,
          dropInDropOut: true,
          entryFee: room.entryFee,
        ),
        isDropIn: true,
      ),
    );
  }

  Future<List<AvailableRoomModel>> getAvailableRooms() async {
    while (_getRoomsSerial != null) {
      try {
        await _getRoomsSerial!;
      } on Exception {
        // Ignore: previous fetch failed; allow retry.
      }
    }
    final gate = Completer<void>();
    _getRoomsSerial = gate.future;
    try {
      return await _fetchAvailableRooms();
    } finally {
      _getRoomsSerial = null;
      if (!gate.isCompleted) gate.complete();
    }
  }

  Future<List<AvailableRoomModel>> _fetchAvailableRooms() async {
    try {
      final responseFuture = _socketService
          .on<List<dynamic>>(JoinGameSessionSocketEvents.availableRoomsResponse)
          .first
          .timeout(_availableRoomsTimeout);
      _socketService.emit(JoinGameSessionSocketEvents.getAvailableRooms);
      final rooms = await responseFuture;
      return rooms
          .whereType<Map<String, dynamic>>()
          .where(_isJoinListStatus)
          .where((m) => !_isVirtualOnlyPartyRow(m))
          .map((m) => _RoomInfoDto.fromJson(m).toModel())
          .toList();
    } on TimeoutException {
      return [];
    } on Exception {
      return [];
    }
  }

  String _normalizeRoomCode(String code) => code.replaceFirst('game_', '');
}

/// Exclut la ligne si le JSON contient une liste `players` et que tous ont
/// `isVirtual: true` (nécessite que le serveur envoie `players` dans la réponse).
bool _isVirtualOnlyPartyRow(Map<String, dynamic> json) {
  final raw = json['players'];
  if (raw is! List<dynamic>) return false;
  final maps = raw.whereType<Map<String, dynamic>>().toList();
  if (maps.isEmpty) return false;
  return maps.every((p) => p['isVirtual'] == true);
}

bool _isJoinListStatus(Map<String, dynamic> json) {
  final status = json['status'];
  if (status is! String) return true;
  // On ignore tout statut inconnu (ex: 'finished') pour ne pas afficher des parties terminées.
  return status == 'waiting' || status == 'playing';
}

class _RoomInfoDto {
  const _RoomInfoDto({
    required this.roomId,
    required this.boardSize,
    required this.boardMatrix,
    required this.status,
    required this.isLocked,
    required this.dropInDropOut,
    required this.playerCount,
    required this.maxPlayers,
    required this.entryFee,
  });

  final String roomId;
  final int boardSize;
  final List<List<GameBoardPreviewCell>> boardMatrix;
  final String status;
  final bool isLocked;
  final bool dropInDropOut;
  final int playerCount;
  final int maxPlayers;
  final int entryFee;

  factory _RoomInfoDto.fromJson(Map<String, dynamic> json) {
    final boardSize = json['boardSize'] as int? ?? 0;
    List<List<GameBoardPreviewCell>> matrix = [];
    final boardRaw = json['board'];
    if (boardRaw is Map<String, dynamic>) {
      try {
        final dto = GameSummaryBoardDto.fromJson(boardRaw);
        matrix = previewMatrixFromGameSummaryBoard(dto);
      } on Exception {
        matrix = defaultPreviewBoardMatrix(boardSize);
      }
    } else {
      matrix = defaultPreviewBoardMatrix(boardSize);
    }
    return _RoomInfoDto(
      roomId: json['roomId'] as String? ?? '',
      boardSize: boardSize,
      boardMatrix: matrix,
      status: json['status'] as String? ?? '',
      isLocked: json['isLocked'] as bool? ?? false,
      dropInDropOut: json['dropInDropOut'] as bool? ?? false,
      playerCount: json['playerCount'] as int? ?? 0,
      maxPlayers: json['maxPlayers'] as int? ?? 0,
      entryFee: json['entryFee'] as int? ?? 0,
    );
  }

  AvailableRoomModel toModel() => AvailableRoomModel(
    roomId: roomId,
    playerCount: playerCount,
    maxPlayers: maxPlayers,
    boardSize: boardSize,
    boardMatrix: boardMatrix,
    status: status,
    isLocked: isLocked,
    dropInDropOut: dropInDropOut,
    entryFee: entryFee,
  );
}
