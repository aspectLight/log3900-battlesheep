import 'dart:async';

import '../models/dto/game_debug_dto.dart';
import '../models/extensions/game_debug_dto_extensions.dart';
import '../models/events/game_debug_socket_events.dart';
import '../../domain/commands/game_debug_commands.dart';
import '../../domain/events/game_debug_events.dart';
import '../../../../core/services/socket_service.dart';

class GameDebugSocket {
  final SocketService _socketService;

  final _debugModeEnabledController =
      StreamController<DebugModeEnabledEvent>.broadcast();
  final _debugModeDisabledController =
      StreamController<DebugModeDisabledEvent>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription> _eventSubscriptions = [];

  GameDebugSocket({required SocketService socketService})
    : _socketService = socketService {
    _connectionSubscription = _socketService.connectionStream.listen((
      connected,
    ) {
      if (!connected) return;
      _setupListeners();
    });
  }

  static const List<String> _ownedEvents = [
    GameDebugSocketEvents.debugModeEnabled,
    GameDebugSocketEvents.debugModeDisabled,
  ];


  void toggleDebugMode(ToggleDebugModeCommand command) {
    _socketService.emit(
      GameDebugSocketEvents.toggleDebugMode,
      command.toDto().toJson(),
    );
  }


  Stream<DebugModeEnabledEvent> get debugModeEnabledStream =>
      _debugModeEnabledController.stream;


  Stream<DebugModeDisabledEvent> get debugModeDisabledStream =>
      _debugModeDisabledController.stream;

  void _setupListeners() {
    _cancelEventListeners();

    _eventSubscriptions.addAll([
      _socketService.on<Object?>(GameDebugSocketEvents.debugModeEnabled).listen(
        (data) {
          _debugModeEnabledController.add(
            DebugModeEnabledDto.fromObject(data).toEntity(),
          );
        },
      ),
      _socketService
          .on<Object?>(GameDebugSocketEvents.debugModeDisabled)
          .listen((data) {
            _debugModeDisabledController.add(
              DebugModeDisabledDto.fromObject(data).toEntity(),
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
    await _debugModeEnabledController.close();
    await _debugModeDisabledController.close();
  }
}
