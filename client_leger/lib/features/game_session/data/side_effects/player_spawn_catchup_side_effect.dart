import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/services/socket_service.dart';
import '../models/events/game_events_socket_events.dart';
import '../../core/context/drop_in_join_sync_holder.dart';

/// Buffers the playerSpawned socket payload at app root so joiners do not miss
/// it before the game session scope registers scoped socket services (Angular
/// keeps listeners from startup; Dart attaches them only after async game load).
class PlayerSpawnCatchupSideEffect with DisposableSideEffect {
  PlayerSpawnCatchupSideEffect({
    required SocketService socketService,
    required DropInJoinSyncHolder dropInJoinSyncHolder,
  }) : _dropInJoinSyncHolder = dropInJoinSyncHolder {
    trackSubscription(
      socketService
          .on<Object?>(GameEventsSocketEvents.playerSpawned)
          .listen(_onPlayerSpawned),
    );
  }

  final DropInJoinSyncHolder _dropInJoinSyncHolder;

  void _onPlayerSpawned(Object? data) {
    if (data is! List) return;
    _dropInJoinSyncHolder.playersRaw = List<dynamic>.from(data);
  }
}
