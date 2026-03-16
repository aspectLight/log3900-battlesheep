import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_debug_state.freezed.dart';

@freezed
class GameDebugState with _$GameDebugState {
  const factory GameDebugState({required bool isDebugMode}) = _GameDebugState;

  factory GameDebugState.initial() => const GameDebugState(isDebugMode: false);
}
