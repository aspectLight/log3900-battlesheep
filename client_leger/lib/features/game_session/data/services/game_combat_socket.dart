import 'dart:async';

import '../models/dto/game_combat_dto.dart';
import '../models/extensions/game_combat_dto_extensions.dart';
import '../models/events/game_combat_socket_events.dart';
import '../../domain/commands/game_combat_commands.dart';
import '../../domain/events/game_combat_events.dart';
import '../../../../core/helpers/socket_numeric_payload.dart';
import '../../../../core/services/socket_service.dart';

class GameCombatSocket {
  final SocketService _socketService;

  final _attackResultController =
      StreamController<AttackResultEvent>.broadcast();
  final _flightAttemptResultController =
      StreamController<FlightAttemptResultEvent>.broadcast();
  final _combatTurnStartedController =
      StreamController<CombatTurnStartedEvent>.broadcast();
  final _endCombatController =
      StreamController<EndCombatResultEvent>.broadcast();
  final _combatCountdownController = StreamController<int>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription> _eventSubscriptions = [];

  GameCombatSocket({required SocketService socketService})
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
    GameCombatSocketEvents.attackResult,
    GameCombatSocketEvents.flightAttemptResult,
    GameCombatSocketEvents.combatTurnStarted,
    GameCombatSocketEvents.updateCombatCountDown,
    GameCombatSocketEvents.endCombat,
  ];


  void startCombat(StartCombatCommand command) {
    _socketService.emit(
      GameCombatSocketEvents.startCombat,
      command.toDto().toJson(),
    );
  }


  void startVirtualCombat(StartVirtualCombatCommand command) {
    _socketService.emit(
      GameCombatSocketEvents.startVirtualCombat,
      command.toDto().toJson(),
    );
  }


  void attack(AttackCommand command) {
    _socketService.emit(
      GameCombatSocketEvents.attack,
      command.toDto().toJson(),
    );
  }


  void flightAttempt(FlightAttemptCommand command) {
    _socketService.emit(GameCombatSocketEvents.flightAttempt, command.roomId);
  }


  Stream<AttackResultEvent> get attackResultStream =>
      _attackResultController.stream;


  Stream<FlightAttemptResultEvent> get flightAttemptResultStream =>
      _flightAttemptResultController.stream;


  Stream<CombatTurnStartedEvent> get combatTurnStartedStream =>
      _combatTurnStartedController.stream;


  Stream<EndCombatResultEvent> get endCombatStream =>
      _endCombatController.stream;


  Stream<int> get combatCountdownStream => _combatCountdownController.stream;

  void _setupListeners() {
    _cancelEventListeners();

    _eventSubscriptions.addAll([
      _socketService
          .on<Map<String, dynamic>>(GameCombatSocketEvents.attackResult)
          .listen((data) {
            _attackResultController.add(
              AttackResultDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(GameCombatSocketEvents.flightAttemptResult)
          .listen((data) {
            _flightAttemptResultController.add(
              FlightAttemptResultDto.fromObject(data).toEntity(),
            );
          }),
      _socketService
          .on<Map<String, dynamic>>(GameCombatSocketEvents.combatTurnStarted)
          .listen((data) {
            _combatTurnStartedController.add(
              CombatTurnStartedDto.fromObject(data).toEntity(),
            );
          }),
      _socketService.on<Object?>(GameCombatSocketEvents.endCombat).listen((
        data,
      ) {
        _endCombatController.add(EndCombatResultDto.fromObject(data).toEntity());
      }),
      _socketService
          .on<Object?>(GameCombatSocketEvents.updateCombatCountDown)
          .listen((data) {
            final v = tryParseSocketWholeNumber(data);
            if (v != null) _combatCountdownController.add(v);
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
    await _attackResultController.close();
    await _flightAttemptResultController.close();
    await _combatTurnStartedController.close();
    await _endCombatController.close();
    await _combatCountdownController.close();
  }
}
