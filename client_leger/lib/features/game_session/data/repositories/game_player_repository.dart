import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_events.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/state/game_player_state.dart';
import '../reducers/game_player_state_reducer.dart';

class GamePlayerRepository {
  final GamePlayerStateReducer _reducer;

  final Signal<GamePlayerState> state = signal(GamePlayerState.initial());

  GamePlayerRepository({required GamePlayerStateReducer reducer})
      : _reducer = reducer;

  void applyPlayersSpawned(PlayerSpawnedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerAbandoned(PlayerAbandonedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyCurrentPlayerChanged(CurrentPlayerChangedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyScoreUpdated(UpdateScoreEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyPlayerMoved(PlayerMovedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyVirtualPlayerMoved(VirtualPlayerMovedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyMovementStep(PlayerMovementStepEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyPlayerIdleReset(PlayerIdleResetEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyTurnStartingPlayerPoints(TurnStartingPlayerPointsEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }


  void applyPlayerHealthUpdated(PlayerHealthUpdatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemCollected(ItemCollectedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemDropped(ItemDroppedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemDroppedDisconnected(ItemDroppedDisconnectedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void decrementActionPointsForPlayer(String playerId) {
    final previous = state.value;
    final idx = previous.indexOf(playerId);
    if (idx < 0) return;
    final player = previous.players[idx];
    final newActionPoints = (player.actionPoints - 1).clamp(0, 999);
    final updated = player.copyWith(actionPoints: newActionPoints);
    final players = List.of(previous.players)..[idx] = updated;
    state.value = previous.copyWith(players: players);
  }
}
