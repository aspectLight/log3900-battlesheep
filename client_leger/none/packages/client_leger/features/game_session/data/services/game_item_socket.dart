import 'dart:async';

import '../models/dto/game_item_dto.dart';
import '../models/extensions/game_item_dto_extensions.dart';
import '../models/events/game_item_socket_events.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/events/game_item_events.dart';
import '../../../../core/services/socket_service.dart';

class GameItemSocket {
  final SocketService _socketService;

  final _itemDroppedController = StreamController<ItemDroppedEvent>.broadcast();
  final _itemCollectedController =
      StreamController<ItemCollectedEvent>.broadcast();
  final _itemDroppedDisconnectedController =
      StreamController<ItemDroppedDisconnectedEvent>.broadcast();
  final _flagCollectedController =
      StreamController<FlagCollectedEvent>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription> _eventSubscriptions = [];

  GameItemSocket({required SocketService socketService})
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
    GameItemSocketEvents.itemDropped,
    GameItemSocketEvents.itemCollected,
    GameItemSocketEvents.itemDroppedDisconnected,
    GameItemSocketEvents.flagCollected,
  ];

  void itemDropped(ItemDroppedCommand command) {
    _socketService.emit(
      GameItemSocketEvents.itemDropped,
      command.toDto().toJson(),
    );
  }

  void itemCollected(ItemCollectedCommand command) {
    _socketService.emit(
      GameItemSocketEvents.itemCollected,
      command.toDto().toJson(),
    );
  }

  Stream<ItemDroppedEvent> get itemDroppedStream =>
      _itemDroppedController.stream;

  Stream<ItemCollectedEvent> get itemCollectedStream =>
      _itemCollectedController.stream;

  Stream<ItemDroppedDisconnectedEvent> get itemDroppedDisconnectedStream =>
      _itemDroppedDisconnectedController.stream;

  Stream<FlagCollectedEvent> get flagCollectedStream =>
      _flagCollectedController.stream;

  void _setupListeners() {
    _cancelEventListeners();

    _eventSubscriptions.addAll([
      _socketService
          .on<Map<String, dynamic>>(GameItemSocketEvents.itemDropped)
          .listen((data) {
            _itemDroppedController.add(
              ItemDroppedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(GameItemSocketEvents.itemCollected)
          .listen((data) {
            _itemCollectedController.add(
              ItemCollectedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(
            GameItemSocketEvents.itemDroppedDisconnected,
          )
          .listen((data) {
            _itemDroppedDisconnectedController.add(
              ItemDroppedDisconnectedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService.on<Object?>(GameItemSocketEvents.flagCollected).listen((
        data,
      ) {
        _flagCollectedController.add(
          FlagCollectedDto.fromObject(data).toEntity(),
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
    await _itemDroppedController.close();
    await _itemCollectedController.close();
    await _itemDroppedDisconnectedController.close();
    await _flagCollectedController.close();
  }
}
