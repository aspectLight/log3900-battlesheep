import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions/game_history_failure.dart';
import '../models/game_history_item.dart';

part 'game_history_state.freezed.dart';

@freezed
sealed class GameHistoryState with _$GameHistoryState {
  const factory GameHistoryState.idle() = GameHistoryStateIdle;

  const factory GameHistoryState.loading() = GameHistoryStateLoading;

  const factory GameHistoryState.loaded({
    required List<GameHistoryItem> items,
  }) = GameHistoryStateLoaded;

  const factory GameHistoryState.error(
    GameHistoryFailure failure,
  ) = GameHistoryStateError;
}
