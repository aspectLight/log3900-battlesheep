import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_board_position.freezed.dart';

@immutable
@freezed
class GameBoardPosition with _$GameBoardPosition {
  const factory GameBoardPosition({required int x, required int y}) =
      _GameBoardPosition;
}
