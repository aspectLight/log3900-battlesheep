import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/join_game_session_events.dart';
import '../../../core/event_bus/join_game_session_event_bus.dart';
import '../../../domain/commands/join_game_session_command.dart';
import '../../../domain/models/available_room_model.dart';
import '../../../domain/state/join_game_session_state.dart';
import '../../../domain/use_cases/get_available_rooms_use_case.dart';
import '../../../domain/use_cases/join_by_code_use_case.dart';

class AvailableRoomsPanelViewModel {
  AvailableRoomsPanelViewModel({
    required JoinByCodeUseCase joinByCodeUseCase,
    required GetAvailableRoomsUseCase getAvailableRoomsUseCase,
    required String socketId,
    required AppTransitionEventBus appTransitionEventBus,
    required JoinGameSessionEventBus joinGameSessionEventBus,
  })  : _joinByCodeUseCase = joinByCodeUseCase,
        _getAvailableRoomsUseCase = getAvailableRoomsUseCase,
        _socketId = socketId,
        _appTransitionEventBus = appTransitionEventBus,
        _joinGameSessionEventBus = joinGameSessionEventBus;

  final JoinByCodeUseCase _joinByCodeUseCase;
  final GetAvailableRoomsUseCase _getAvailableRoomsUseCase;
  final String _socketId;
  final AppTransitionEventBus _appTransitionEventBus;
  final JoinGameSessionEventBus _joinGameSessionEventBus;

  final rooms = signal<List<AvailableRoomModel>>([]);
  final isLoading = signal(false);
  final joinState = signal<JoinGameSessionState>(
    const JoinGameSessionState.initial(),
  );

  bool get isJoining => joinState.value is JoinGameSessionStateLoading;

  Future<void> loadRooms({bool showLoading = false}) async {
    if (isLoading.value) return;
    if (showLoading) {
      isLoading.value = true;
    }
    final fetched = await _getAvailableRoomsUseCase.execute();
    rooms.value = fetched;
    if (showLoading) {
      isLoading.value = false;
    }
  }

  Future<void> onRoomTap(AvailableRoomModel room) async {
    if (!room.isJoinable || isJoining) return;
    joinState.value = const JoinGameSessionState.loading();
    final result = await _joinByCodeUseCase.execute(
      JoinGameSessionCommand(
        roomCode: room.fourDigitCode,
        socketId: _socketId,
      ),
    );
    result.match(
      (failure) {
        joinState.value = JoinGameSessionState.error(failure);
        _joinGameSessionEventBus.fire(JoinGameSessionFailureEvent(failure));
      },
      (joinResult) {
        joinState.value = const JoinGameSessionState.success();
        _appTransitionEventBus.fire(
          JoinGameSessionExitAppEvent.joinSucceeded(joinResult),
        );
      },
    );
  }
}
