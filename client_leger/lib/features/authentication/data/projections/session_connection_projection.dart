import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../domain/commands/session_commands.dart';
import '../../data/repositories/session_repository.dart';
import '../../../../core/services/socket_service.dart';
import '../../domain/state/session_state.dart';

class SessionConnectionProjection implements EventProjection {
  final SocketService _socketService;
  final SessionRepository _sessionRepository;

  SessionConnectionProjection({
    required SocketService socketService,
    required SessionRepository sessionRepository,
  }) : _socketService = socketService,
       _sessionRepository = sessionRepository {
    _sessionRepository.setSessionState(SetSessionStateCommand(
      sessionState: _socketService.isConnected
          ? _socketService.socketIdOption.fold(
              SessionState.initial,
              SessionState.connected,
            )
          : const SessionState.initial(),
    ));
  }

  @override
  List<StreamSubscription> subscribe() => [
    _socketService.connectionStream.listen((connected) {
      _sessionRepository.setSessionState(SetSessionStateCommand(
        sessionState: connected
            ? _socketService.socketIdOption.fold(
                SessionState.initial,
                SessionState.connected,
              )
            : const SessionState.initial(),
      ));
    }),
  ];
}
