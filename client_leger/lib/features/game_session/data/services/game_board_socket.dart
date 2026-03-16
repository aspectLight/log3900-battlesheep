import 'dart:async';

import '../models/dto/game_events_dto.dart';
import '../models/extensions/game_events_dto_extensions.dart';
import '../models/events/game_board_socket_events.dart';
import '../../domain/commands/game_door_commands.dart';
import '../../domain/events/game_events.dart';
import '../../../../core/services/socket_service.dart';

class GameBoardSocket {
  final SocketService _socketService;
  final _doorToggledController = StreamController<DoorToggledEvent>.broadcast();
  final List<StreamSubscription> _eventSubscriptions = [];
  StreamSubscription<bool>? _connectionSubscription;

  GameBoardSocket({required SocketService socketService})
    : _socketService = socketService {
    _connectionSubscription = _socketService.connectionStream.listen((
      connected,
    ) {
      if (!connected) return;
      _setupListeners();
    });
  }

  void toggleDoor(ToggleDoorCommand command) {
    _socketService.emit(
      GameBoardSocketEvents.doorToggled,
      command.toDto().toJson(),
    );
  }

  Stream<DoorToggledEvent> get doorToggledStream =>
      _doorToggledController.stream;

  void _setupListeners() {
    _cancelEventListeners();
    _eventSubscriptions.add(
      _socketService
          .on<Map<String, dynamic>>(GameBoardSocketEvents.doorToggled)
          .listen((data) {
            _doorToggledController.add(
              DoorToggledDto.fromObject(data).toEntity(),
            );
          }),
    );
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
    _socketService.off(GameBoardSocketEvents.doorToggled);
    await _doorToggledController.close();
  }
}
