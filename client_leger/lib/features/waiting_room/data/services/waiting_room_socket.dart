import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/merge_profile_avatar_into_player_payload.dart';
import '../../../../core/helpers/replay_latest_broadcast_controller.dart';
import '../../../../core/helpers/socket_listener_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../core/exceptions/waiting_room_failure.dart';
import '../../domain/commands/add_virtual_player_command.dart';
import '../../domain/commands/create_waiting_room_command.dart';
import '../../domain/commands/get_reserved_characters_command.dart';
import '../../domain/commands/kick_player_command.dart';
import '../../domain/commands/leave_waiting_room_command.dart';
import '../../domain/commands/reserve_character_command.dart';
import '../../domain/commands/toggle_lock_waiting_room_command.dart';
import '../../domain/models/reservation_model.dart';
import '../../domain/models/waiting_room_model.dart';
import '../../domain/models/waiting_room_player_model.dart';
import '../models/dto/game_room_created_payload_dto.dart';
import '../models/dto/player_created_payload_dto.dart';
import '../models/dto/player_left_payload_dto.dart';
import '../models/dto/reserve_character_ack_dto.dart';
import '../models/dto/update_character_reserved_payload_dto.dart';
import '../models/dto/waiting_room_command_ack_dto.dart';
import '../models/dto/waiting_room_dto.dart';
import '../models/events/waiting_room_socket_events.dart';
import '../models/extensions/add_virtual_player_command_to_dto_extensions.dart';
import '../models/extensions/create_waiting_room_command_to_dto_extensions.dart';
import '../models/extensions/get_reserved_characters_command_to_dto_extensions.dart';
import '../models/extensions/kick_player_command_to_dto_extensions.dart';
import '../models/extensions/player_created_payload_dto_extensions.dart';
import '../models/extensions/reservation_dto_extensions.dart';
import '../models/extensions/reserve_character_command_to_dto_extensions.dart';
import '../models/extensions/waiting_room_dto_extensions.dart';
import '../models/extensions/waiting_room_error_payload_dto_extensions.dart';

class WaitingRoomSocket {
  WaitingRoomSocket({
    required SocketService socketService,
    required AuthRepository authRepository,
  }) : _socketService = socketService,
       _authRepository = authRepository {
    _connectionSubscription = _socketService.connectionStream.listen((
      connected,
    ) async {
      if (!connected) return;
      await _setupListeners();
    });
    if (_socketService.isConnected) {
      unawaited(_setupListeners());
    }
  }

  final SocketService _socketService;
  final AuthRepository _authRepository;

  final _waitingRoomCreatedController =
      ReplayLatestBroadcastController<WaitingRoomModel>();
  final _roomCanceledController = StreamController<void>.broadcast();
  final _roomLockedController = StreamController<void>.broadcast();
  final _roomUnlockedController = StreamController<void>.broadcast();
  final _dropInDropOutToggledController = StreamController<bool>.broadcast();
  final _playerLeftController = StreamController<String>.broadcast();
  final _playerCreatedController =
      StreamController<List<WaitingRoomPlayerModel>>.broadcast();
  final _playerKickedController = StreamController<void>.broadcast();
  final _updateCharacterReservedController =
      ReplayLatestBroadcastController<List<ReservationModel>>();
  final _waitingRoomErrorController =
      StreamController<WaitingRoomFailure>.broadcast();
  final _gameRoomCreatedController =
      StreamController<GameRoomCreatedPayloadDto>.broadcast();

  final List<StreamSubscription<dynamic>> _eventSubscriptions = [];
  StreamSubscription<bool>? _connectionSubscription;

  static final List<String> _ownedEvents = [
    WaitingRoomSocketEvents.inbound.waitingRoomCreated,
    WaitingRoomSocketEvents.inbound.leaveRoomResponse,
    WaitingRoomSocketEvents.inbound.roomCanceled,
    WaitingRoomSocketEvents.inbound.waitingRoomLocked,
    WaitingRoomSocketEvents.inbound.waitingRoomUnlocked,
    WaitingRoomSocketEvents.inbound.dropInDropOutToggled,
    WaitingRoomSocketEvents.inbound.playerLeft,
    WaitingRoomSocketEvents.inbound.playerCreated,
    WaitingRoomSocketEvents.inbound.playerKicked,
    WaitingRoomSocketEvents.inbound.updateAvatarReserved,
    WaitingRoomSocketEvents.inbound.waitingRoomError,
    WaitingRoomSocketEvents.inbound.gameRoomCreated,
  ];

  Stream<GameRoomCreatedPayloadDto> get gameRoomCreatedStream =>
      _gameRoomCreatedController.stream;

  Stream<WaitingRoomModel> get waitingRoomCreatedStream =>
      _waitingRoomCreatedController.stream;
  Stream<void> get roomCanceledStream => _roomCanceledController.stream;
  Stream<void> get roomLockedStream => _roomLockedController.stream;
  Stream<void> get roomUnlockedStream => _roomUnlockedController.stream;
  Stream<bool> get dropInDropOutToggledStream =>
      _dropInDropOutToggledController.stream;
  Stream<String> get playerLeftStream => _playerLeftController.stream;
  Stream<List<WaitingRoomPlayerModel>> get playerCreatedStream =>
      _playerCreatedController.stream;
  Stream<void> get playerKickedStream => _playerKickedController.stream;
  Stream<List<ReservationModel>> get updateCharacterReservedStream =>
      _updateCharacterReservedController.stream;
  Stream<WaitingRoomFailure> get waitingRoomErrorStream =>
      _waitingRoomErrorController.stream;

  Future<void> _setupListeners() async {
    await _cancelEventListeners();
    _eventSubscriptions.addAll([
      _socketService
          .on<Object?>(WaitingRoomSocketEvents.inbound.waitingRoomCreated)
          .listen((data) {
            if (data is! Map) return;
            _waitingRoomCreatedController.add(
              WaitingRoomDto.fromJson(Map<String, dynamic>.from(data)).toModel(),
            );
          }),
      subscribeSocketEvent<Object?>(
        _socketService,
        WaitingRoomSocketEvents.inbound.roomCanceled,
        _roomCanceledController,
        (_) => null,
      ),
      subscribeSocketEvent<Object?>(
        _socketService,
        WaitingRoomSocketEvents.inbound.waitingRoomLocked,
        _roomLockedController,
        (_) => null,
      ),
      subscribeSocketEvent<Object?>(
        _socketService,
        WaitingRoomSocketEvents.inbound.waitingRoomUnlocked,
        _roomUnlockedController,
        (_) => null,
      ),
      subscribeSocketEvent<Map<String, dynamic>>(
        _socketService,
        WaitingRoomSocketEvents.inbound.dropInDropOutToggled,
        _dropInDropOutToggledController,
        (data) => data['dropInDropOut'] as bool? ?? false,
      ),
      subscribeSocketEvent<Map<String, dynamic>>(
        _socketService,
        WaitingRoomSocketEvents.inbound.playerLeft,
        _playerLeftController,
        (data) => PlayerLeftPayloadDto.fromJson(data).playerId,
      ),
      subscribeSocketEvent<Object?>(
        _socketService,
        WaitingRoomSocketEvents.inbound.playerKicked,
        _playerKickedController,
        (_) => null,
      ),
      _socketService
          .on<Object?>(WaitingRoomSocketEvents.inbound.updateAvatarReserved)
          .listen((data) {
            if (data is! Map) return;
            _updateCharacterReservedController.add(
              UpdateCharacterReservedPayloadDto.fromJson(
                Map<String, dynamic>.from(data),
              ).reservedCharacters.map((d) => d.toModel()).toList(),
            );
          }),
      subscribeSocketEvent<Object?>(
        _socketService,
        WaitingRoomSocketEvents.inbound.waitingRoomError,
        _waitingRoomErrorController,
        (data) => data.toWaitingRoomErrorPayloadDto().toFailure(),
      ),
      subscribeSocketEvent<List<dynamic>>(
        _socketService,
        WaitingRoomSocketEvents.inbound.playerCreated,
        _playerCreatedController,
        (data) => PlayerCreatedPayloadDto.fromList(data).toModels(),
      ),
      _socketService
          .on<Object?>(WaitingRoomSocketEvents.inbound.gameRoomCreated)
          .listen((data) {
            if (data is! Map) return;
            _gameRoomCreatedController.add(
              GameRoomCreatedPayloadDto.fromJson(
                Map<String, dynamic>.from(data),
              ),
            );
          }),
    ]);
  }

  Future<void> _cancelEventListeners() async {
    for (final sub in _eventSubscriptions) {
      await sub.cancel();
    }
    _eventSubscriptions.clear();
  }

  void createWaitingRoom(CreateWaitingRoomCommand command) {
    unawaited(_createWaitingRoom(command));
  }

  Future<void> _createWaitingRoom(CreateWaitingRoomCommand command) async {
    final payload = command.toCreateWaitingRoomPayloadDto().toJson();
    final host = payload['host'];
    if (host is Map<String, dynamic>) {
      final uid = await _resolveFirebaseUid();
      if (uid != null && uid.isNotEmpty) {
        host['firebaseUid'] = uid;
      }
      await mergeProfileAvatarFieldsFromAuth(_authRepository, host);
    }
    _socketService.emit(
      WaitingRoomSocketEvents.outbound.createWaitingRoom,
      payload,
    );
  }

  Future<String?> _resolveFirebaseUid() async {
    final currentUserResult = await _authRepository.getCurrentUser().run();
    return switch (currentUserResult) {
      Left() => null,
      Right(value: final userOption) => switch (userOption) {
        Some(value: final user) => user.firebaseUid,
        None() => null,
      },
    };
  }

  Future<Either<WaitingRoomFailure, void>> leaveWaitingRoom(
    LeaveWaitingRoomCommand command,
  ) async {
    final responseFuture = _socketService
        .on<Map<String, dynamic>>(
          WaitingRoomSocketEvents.inbound.leaveRoomResponse,
        )
        .first;
    _socketService.emit(
      WaitingRoomSocketEvents.outbound.leaveWaitingRoom,
      command.roomId,
    );
    final response = await responseFuture;
    final ack = WaitingRoomCommandAckDto.fromJson(response);
    if (ack.success) return right(null);
    return left(ack.error.toWaitingRoomFailure());
  }

  void toggleLockWaitingRoom(ToggleLockWaitingRoomCommand command) {
    _socketService.emit(
      WaitingRoomSocketEvents.outbound.toggleLockWaitingRoom,
      command.roomId,
    );
  }

  void toggleDropInDropOut(String roomId) {
    _socketService.emit(
      WaitingRoomSocketEvents.outbound.toggleDropInDropOut,
      roomId,
    );
  }

  void kickPlayer(KickPlayerCommand command) {
    final payload = command.toKickPlayerPayloadDto().toJson();
    _socketService.emit(WaitingRoomSocketEvents.outbound.kickPlayer, payload);
  }

  void createPlayer(AddVirtualPlayerCommand command) {
    final payload = command.toCreatePlayerPayloadDto().toJson();
    _socketService.emit(WaitingRoomSocketEvents.outbound.createPlayer, payload);
  }

  Future<Either<WaitingRoomFailure, void>> startGame(String roomId) {
    return _socketService.emitWithAckEither<WaitingRoomFailure, void>(
      WaitingRoomSocketEvents.outbound.startGame,
      roomId,
      (data) {
        if (data == null) return right(null);
        if (data is! Map<String, dynamic>) return right(null);
        final ack = WaitingRoomCommandAckDto.fromJson(data);
        if (ack.success) return right(null);
        return left(const StartGameFailedWaitingRoomFailure());
      },
    );
  }

  Future<Either<WaitingRoomFailure, void>> reserveCharacter(
    ReserveCharacterCommand command,
  ) {
    return _socketService.emitWithAckEither<WaitingRoomFailure, void>(
      WaitingRoomSocketEvents.outbound.reserveAvatar,
      command.toReserveCharacterCommandDto().toJson(),
      (data) {
        if (data == null) return right(null);
        if (data is! Map<String, dynamic>) return right(null);
        final dto = ReserveCharacterAckDto.fromJson(data);
        if (dto.success) return right(null);
        final ack = WaitingRoomCommandAckDto.fromJson(data);
        if (ack.error != null && ack.error!.isNotEmpty) {
          return left(ack.error.toWaitingRoomFailure());
        }
        return left(const CharacterAlreadyReservedWaitingRoomFailure());
      },
    );
  }

  void getReservedCharacters(GetReservedCharactersCommand command) {
    final payload = command.toGetReservedCharactersCommandDto().toJson();
    _socketService.emit(
      WaitingRoomSocketEvents.outbound.getReservedAvatars,
      payload,
    );
  }

  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    for (final subscription in _eventSubscriptions) {
      await subscription.cancel();
    }
    _eventSubscriptions.clear();
    _ownedEvents.forEach(_socketService.off);
    await _waitingRoomCreatedController.close();
    await _roomCanceledController.close();
    await _roomLockedController.close();
    await _roomUnlockedController.close();
    await _dropInDropOutToggledController.close();
    await _playerLeftController.close();
    await _playerCreatedController.close();
    await _playerKickedController.close();
    await _updateCharacterReservedController.close();
    await _waitingRoomErrorController.close();
    await _gameRoomCreatedController.close();
  }
}
