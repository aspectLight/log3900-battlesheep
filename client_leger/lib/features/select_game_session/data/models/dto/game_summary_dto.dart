import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/game_mode_converter.dart';
import '../../../../../core/enums/game_mode.dart';

part 'game_summary_dto.g.dart';

@JsonSerializable()
class GameSummaryBoardDto {
  final int size;

  const GameSummaryBoardDto({required this.size});

  factory GameSummaryBoardDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryBoardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryBoardDtoToJson(this);
}

@JsonSerializable()
class GameSummaryDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  @JsonKey(defaultValue: '')
  final String description;
  @GameModeConverter()
  final GameMode mode;
  final GameSummaryBoardDto board;
  final bool isVisible;
  final String modificationDate;

  const GameSummaryDto({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.board,
    required this.isVisible,
    required this.modificationDate,
  });

  factory GameSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryDtoToJson(this);
}


