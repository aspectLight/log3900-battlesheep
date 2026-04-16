import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_environment_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../models/dto/game_player_movement_dto.dart';
import '../models/dto/game_trap_torch_dto.dart';
import '../models/events/game_player_movement_socket_events.dart';
import '../models/extensions/game_player_movement_dto_extensions.dart';
import '../models/extensions/game_trap_torch_dto_extensions.dart';

class GamePlayerMovementSocket {
  final SocketService _socketService;

  final _reachablePathsResponseController =
      StreamController<ReachablePathsResponseEvent>.broadcast();
  final _playerMovedController = StreamController<PlayerMovedEvent>.broadcast();
  final _playerTeleportedController =
      StreamController<PlayerTeleportedEvent>.broadcast();
  final _virtualPlayerMovedController =
      StreamController<VirtualPlayerMovedEvent>.broadcast();
  final _synchronizeMovementController =
      StreamController<SynchronizeMovementEvent>.broadcast();
  final _trapPendingController = StreamController<TrapPendingEvent>.broadcast();
  final _trapResultController =
      StreamController<TrapResultSyncEvent>.broadcast();
  final _torchIlluminationController =
      StreamController<TorchIlluminationUpdateDto>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription> _eventSubscriptions = [];

  GamePlayerMovementSocket({required SocketService socketService})
    : _socketService = socketService {
    _connectionSubscription = _socketService.connectionStream.listen((
      connected,
    ) {
      if (!connected) return;
      _setupListeners();
    });
    if (_socketService.isConnected) {
      _setupListeners();
    }
  }

  static const List<String> _ownedEvents = [
    GamePlayerMovementSocketEvents.playerMoved,
    GamePlayerMovementSocketEvents.playerTeleported,
    GamePlayerMovementSocketEvents.virtualPlayerMoved,
    GamePlayerMovementSocketEvents.synchronizeMovement,
    GamePlayerMovementSocketEvents.trapPending,
    GamePlayerMovementSocketEvents.trapResult,
    GamePlayerMovementSocketEvents.torchIlluminationUpdate,
  ];

  Stream<ReachablePathsResponseEvent> get reachablePathsResponseStream =>
      _reachablePathsResponseController.stream;

  Stream<TrapPendingEvent> get trapPendingStream =>
      _trapPendingController.stream;

  Stream<TrapResultSyncEvent> get trapResultStream =>
      _trapResultController.stream;

  Stream<TorchIlluminationUpdateDto> get torchIlluminationStream =>
      _torchIlluminationController.stream;

  Future<void> playerGetMovements(PlayerGetMovementsCommand command) async {
    final response = await _socketService.emitWithAck<Object?>(
      GamePlayerMovementSocketEvents.playerGetMovements,
      command.toDto().toJson(),
    );
    if (response == null) {
      _reachablePathsResponseController.add(
        const ReachablePathsResponseEvent(paths: []),
      );
      return;
    }
    final map = response as Map<String, dynamic>;
    final success = map['success'] as bool? ?? false;
    if (!success) {
      _reachablePathsResponseController.add(
        const ReachablePathsResponseEvent(paths: []),
      );
      return;
    }
    final paths = map['paths'];
    if (paths == null || (paths as List).isEmpty) {
      _reachablePathsResponseController.add(
        const ReachablePathsResponseEvent(paths: []),
      );
      return;
    }
    _reachablePathsResponseController.add(
      ReachablePathsResponseDto.fromObject(map).toEntity(),
    );
  }

  void playerMoved(PlayerMovedCommand command) {
    _socketService.emit(
      GamePlayerMovementSocketEvents.playerMoved,
      command.toDto().toJson(),
    );
  }

  void playerTeleported(PlayerTeleportedCommand command) {
    _socketService.emit(
      GamePlayerMovementSocketEvents.playerTeleported,
      command.toDto().toJson(),
    );
  }

  void synchronizeMovement(SynchronizeMovementCommand command) {
    _socketService.emit(
      GamePlayerMovementSocketEvents.synchronizeMovement,
      command.toDto().toJson(),
    );
  }

  void trapChoice(TrapChoiceCommand command) {
    _socketService.emit(
      GamePlayerMovementSocketEvents.trapChoice,
      command.toDto().toJson(),
    );
  }

  Stream<PlayerMovedEvent> get playerMovedStream =>
      _playerMovedController.stream;

  Stream<PlayerTeleportedEvent> get playerTeleportedStream =>
      _playerTeleportedController.stream;

  Stream<VirtualPlayerMovedEvent> get virtualPlayerMovedStream =>
      _virtualPlayerMovedController.stream;

  Stream<SynchronizeMovementEvent> get synchronizeMovementStream =>
      _synchronizeMovementController.stream;

  void _setupListeners() {
    _cancelEventListeners();

    _eventSubscriptions.addAll([
      _socketService
          .on<Map<String, dynamic>>(GamePlayerMovementSocketEvents.playerMoved)
          .listen((data) {
            _playerMovedController.add(
              PlayerMovedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(
            GamePlayerMovementSocketEvents.playerTeleported,
          )
          .listen((data) {
            _playerTeleportedController.add(
              PlayerTeleportedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(
            GamePlayerMovementSocketEvents.virtualPlayerMoved,
          )
          .listen((data) {
            _virtualPlayerMovedController.add(
              VirtualPlayerMovedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(
            GamePlayerMovementSocketEvents.synchronizeMovement,
          )
          .listen((data) {
            _synchronizeMovementController.add(
              SynchronizeMovementDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(GamePlayerMovementSocketEvents.trapPending)
          .listen((data) {
            _trapPendingController.add(
              TrapPendingDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(GamePlayerMovementSocketEvents.trapResult)
          .listen((data) {
            _trapResultController.add(
              TrapResultDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(
            GamePlayerMovementSocketEvents.torchIlluminationUpdate,
          )
          .listen((data) {
            _torchIlluminationController.add(
              TorchIlluminationUpdateDto.fromObject(data),
            );
          }),
    ]);
  }

  void _cancelEventListeners() {
    for (final sub in _eventSubscriptions) {
      unawaited(sub.cancel());
    }
    _eventSubscriptions.clear();
  }

  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    for (final subscription in _eventSubscriptions) {
      await subscription.cancel();
    }
    _eventSubscriptions.clear();
    _ownedEvents.forEach(_socketService.off);
    await _reachablePathsResponseController.close();
    await _playerMovedController.close();
    await _playerTeleportedController.close();
    await _virtualPlayerMovedController.close();
    await _synchronizeMovementController.close();
    await _trapPendingController.close();
    await _trapResultController.close();
    await _torchIlluminationController.close();
  }
}
