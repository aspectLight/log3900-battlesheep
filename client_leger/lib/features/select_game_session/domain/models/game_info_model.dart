import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/game_mode.dart';

part 'game_info_model.freezed.dart';

@freezed
class GameModelInfo with _$GameModelInfo {
  const factory GameModelInfo({
    required String id,
    required String name,
    required String description,
    required GameMode mode,
    required int boardSize,
    required bool isVisible,
    required String lastModified,
  }) = _GameModelInfo;
}
