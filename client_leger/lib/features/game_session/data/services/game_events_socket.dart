import 'dart:async';

import '../models/dto/game_events_dto.dart';
import '../models/extensions/game_events_dto_extensions.dart';
import '../models/events/game_events_socket_events.dart';
import '../../domain/events/game_events.dart';
import '../../../../core/services/socket_service.dart';

class GameEventsSocket {
  final SocketService _socketService;

  final _playerSpawnedController =
      StreamController<PlayerSpawnedEvent>.broadcast();
  final _turnStartingController =
      StreamController<TurnStartingEvent>.broadcast();
  final _updateCountdownController =
      StreamController<UpdateCountdownEvent>.broadcast();
  final _updateStartingCountdownController =
      StreamController<UpdateStartingCountdownEvent>.broadcast();
  final _updateScoreController = StreamController<UpdateScoreEvent>.broadcast();
  final _finishGameController = StreamController<FinishGameEvent>.broadcast();
  final _gameCanceledController =
      StreamController<GameCanceledEvent>.broadcast();
  final _gameAbandonedController =
      StreamController<GameAbandonedEvent>.broadcast();
  final _playerAbandonedController =
      StreamController<PlayerAbandonedEvent>.broadcast();
  final _organizatorChangedController =
      StreamController<OrganizatorChangedEvent>.broadcast();

  final List<StreamSubscription> _eventSubscriptions = [];
  StreamSubscription<bool>? _connectionSubscription;

  GameEventsSocket({required SocketService socketService})
    : _socketService = socketService {
    _connectionSubscription = _socketService.connectionStream.listen((
      connected,
    ) {
      if (!connected) return;
      _setupListeners();
    });
  }

  static const List<String> _ownedEvents = [
    GameEventsSocketEvents.playerSpawned,
    GameEventsSocketEvents.turnStarting,
    GameEventsSocketEvents.updateCountdown,
    GameEventsSocketEvents.updateStartingCountdown,
    GameEventsSocketEvents.updateScore,
    GameEventsSocketEvents.finishGame,
    GameEventsSocketEvents.gameCanceled,
    GameEventsSocketEvents.gameAbandoned,
    GameEventsSocketEvents.playerAbandoned,
    GameEventsSocketEvents.organizatorChanged,
  ];


  Stream<PlayerSpawnedEvent> get playerSpawnedStream =>
      _playerSpawnedController.stream;

  Stream<TurnStartingEvent> get turnStartingStream =>
      _turnStartingController.stream;

  Stream<UpdateCountdownEvent> get updateCountdownStream =>
      _updateCountdownController.stream;

  Stream<UpdateStartingCountdownEvent> get updateStartingCountdownStream =>
      _updateStartingCountdownController.stream;

  Stream<UpdateScoreEvent> get updateScoreStream =>
      _updateScoreController.stream;

  Stream<FinishGameEvent> get finishGameStream => _finishGameController.stream;

  Stream<GameCanceledEvent> get gameCanceledStream =>
      _gameCanceledController.stream;

  Stream<GameAbandonedEvent> get gameAbandonedStream =>
      _gameAbandonedController.stream;

  Stream<PlayerAbandonedEvent> get playerAbandonedStream =>
      _playerAbandonedController.stream;

  Stream<OrganizatorChangedEvent> get organizatorChangedStream =>
      _organizatorChangedController.stream;

  void emitPlayGame(String roomId) {
    _socketService.emit(GameEventsSocketEvents.playGame, roomId);
  }

  void _setupListeners() {
    _cancelEventListeners();

    _eventSubscriptions.addAll([
      _socketService
          .on<List<dynamic>>(GameEventsSocketEvents.playerSpawned)
          .listen((data) {
            _playerSpawnedController.add(data.toPlayerSpawnedDto().toEntity());
          }),
      _socketService
          .on<Map<String, dynamic>>(GameEventsSocketEvents.turnStarting)
          .listen((data) {
            _turnStartingController.add(
              TurnStartingDto.fromObject(data).toEntity(),
            );
          }),
      _socketService.on<int>(GameEventsSocketEvents.updateCountdown).listen((
        data,
      ) {
        _updateCountdownController.add(
          UpdateCountdownDto.fromObject(data).toEntity(),
        );
      }),
      _socketService
          .on<int>(GameEventsSocketEvents.updateStartingCountdown)
          .listen((data) {
            _updateStartingCountdownController.add(
              UpdateStartingCountdownDto.fromObject(data).toEntity(),
            );
          }),
      _socketService.on<String>(GameEventsSocketEvents.updateScore).listen((
        data,
      ) {
        _updateScoreController.add(
          UpdateScoreDto.fromObject(data).toEntity(),
        );
      }),
      _socketService.on<String>(GameEventsSocketEvents.finishGame).listen((
        data,
      ) {
        _finishGameController.add(
          FinishGameDto.fromObject(data).toEntity(),
        );
      }),
      _socketService
          .on<Map<String, dynamic>>(GameEventsSocketEvents.gameCanceled)
          .listen((data) {
            _gameCanceledController.add(
              GameCanceledDto.fromObject(data).toEntity(),
            );
          }),
      _socketService.on<Object?>(GameEventsSocketEvents.gameAbandoned).listen((
        data,
      ) {
        _gameAbandonedController.add(
          GameAbandonedDto.fromObject(data).toEntity(),
        );
      }),
      _socketService.on<String>(GameEventsSocketEvents.playerAbandoned).listen((
        data,
      ) {
        _playerAbandonedController.add(
          PlayerAbandonedDto.fromObject(data).toEntity(),
        );
      }),
      _socketService
          .on<Map<String, dynamic>>(GameEventsSocketEvents.organizatorChanged)
          .listen((data) {
            _organizatorChangedController.add(
              OrganizatorChangedDto.fromObject(data).toEntity(),
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
    await _playerSpawnedController.close();
    await _turnStartingController.close();
    await _updateCountdownController.close();
    await _updateStartingCountdownController.close();
    await _updateScoreController.close();
    await _finishGameController.close();
    await _gameCanceledController.close();
    await _gameAbandonedController.close();
    await _playerAbandonedController.close();
    await _organizatorChangedController.close();
  }
}
