import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../data/models/extensions/room_to_waiting_room_model.dart';
import '../../data/repositories/waiting_room_reservations_repository.dart';
import '../app_events/waiting_room_events.dart';
import '../context/waiting_room_entry_data.dart';
import '../context/waiting_room_scope_holder.dart';
import '../di/waiting_room_module.dart';

class WaitingRoomCoordinator
    extends
        AutoScopeCoordinator<
          WaitingRoomEntryData,
          WaitingRoomEntryAppEvent,
          WaitingRoomCompletedAppEvent,
          WaitingRoomExitAppEvent
        > {
  WaitingRoomCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.scopeHolder,
    required this.appNavigator,
  });

  final GetIt getIt;
  @override
  final SessionScopeManager sessionScopeManager;
  final WaitingRoomScopeHolder scopeHolder;
  final AppNavigator appNavigator;

  @override
  final String scopeName = 'waiting_room';

  @override
  bool get tearDownStaleFeatureScopeOnEntry => true;

  @override
  void onScopeCreated(GetIt scope) {
    scopeHolder.setScope(scope);
    registerWaitingRoomScope(scope, getIt, entryData: entryData);
    scope.get<WaitingRoomReservationsRepository>().requestReservedCharacters();
  }

  @override
  void onScopeDropped() {
    scopeHolder.clearScope();
  }

  @override
  Future<WaitingRoomEntryData?> onEntryImpl(
    WaitingRoomEntryAppEvent event,
  ) async {
    appNavigator.request(GoToWaitingRoom());
    return switch (event) {
      WaitingRoomEnteredAsHost(
        :final roomId,
        :final hostId,
        :final socketId,
        :final gameName,
        :final gameDescription,
        :final boardSize,
        :final isCTF,
      ) =>
        WaitingRoomEntryData.host(
          roomId: roomId,
          hostId: hostId,
          socketId: socketId,
          gameName: gameName,
          gameDescription: gameDescription,
          boardSize: boardSize,
          isCTF: isCTF,
        ),
      WaitingRoomEnteredAsJoin(
        :final roomId,
        :final hostId,
        :final socketId,
        :final gameName,
        :final gameDescription,
        :final initialRoom,
      ) =>
        WaitingRoomEntryData.join(
          roomId: roomId,
          hostId: hostId,
          socketId: socketId,
          gameName: gameName,
          gameDescription: gameDescription,
          initialRoom: initialRoom.toWaitingRoomModel(),
        ),
    };
  }

  @override
  Future<void> onCompletedImpl(
    WaitingRoomCompletedAppEvent event,
    WaitingRoomEntryData data,
  ) async {}

  @override
  Future<void> onExitImpl(
    WaitingRoomExitAppEvent event,
    WaitingRoomEntryData data,
  ) async {
    appNavigator.request(ExitToMainMenu());
  }
}
