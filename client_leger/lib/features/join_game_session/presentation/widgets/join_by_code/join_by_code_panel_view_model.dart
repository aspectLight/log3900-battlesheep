import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/join_game_session_events.dart';
import '../../../core/event_bus/join_game_session_event_bus.dart';
import '../../../core/utils/join_game_session_qr_payload_parser.dart';
import '../../../domain/commands/join_game_session_command.dart';
import '../../../domain/state/join_game_session_state.dart';
import '../../../domain/use_cases/join_by_code_use_case.dart';

class JoinByCodePanelViewModel {
  JoinByCodePanelViewModel({
    required JoinByCodeUseCase joinByCodeUseCase,
    required String socketId,
    required AppTransitionEventBus appTransitionEventBus,
    required JoinGameSessionEventBus joinGameSessionEventBus,
  }) : _joinByCodeUseCase = joinByCodeUseCase,
       _socketId = socketId,
       _appTransitionEventBus = appTransitionEventBus,
       _joinGameSessionEventBus = joinGameSessionEventBus;

  final JoinByCodeUseCase _joinByCodeUseCase;
  final String _socketId;
  final AppTransitionEventBus _appTransitionEventBus;
  final JoinGameSessionEventBus _joinGameSessionEventBus;

  final code = signal('');
  final joinState = signal<JoinGameSessionState>(
    const JoinGameSessionState.initial(),
  );

  bool get isJoining => joinState.value is JoinGameSessionStateLoading;

  void onCodeChanged(String value) {
    code.value = value;
  }

  void applyDetectedRoomCode(String raw) {
    final String? parsed = JoinGameSessionQrPayloadParser.tryParseRoomCode(raw);
    if (parsed != null) {
      code.value = parsed;
    }
  }

  Future<void> onJoinTap() async {
    if (isJoining) return;
    final normalizedCode = code.value.trim();
    joinState.value = const JoinGameSessionState.loading();
    final result = await _joinByCodeUseCase.execute(
      JoinGameSessionCommand(roomCode: normalizedCode, socketId: _socketId),
    );
    result.match(
      (failure) {
        joinState.value = JoinGameSessionState.error(failure);
        _joinGameSessionEventBus.fire(JoinGameSessionFailureEvent(failure));
      },
      (result) {
        joinState.value = const JoinGameSessionState.success();
        _appTransitionEventBus.fire(
          JoinGameSessionExitAppEvent.joinSucceeded(result),
        );
      },
    );
  }
}
