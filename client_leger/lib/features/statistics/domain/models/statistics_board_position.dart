import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_board_position.freezed.dart';

@immutable
@freezed
class StatisticsBoardPosition with _$StatisticsBoardPosition {
  const factory StatisticsBoardPosition({required int x, required int y}) =
      _StatisticsBoardPosition;
}
