import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/game_mode_converter.dart';
import '../../../../../core/enums/game_mode.dart';

part 'game_summary_dto.g.dart';

@JsonSerializable()
class GameSummaryBoardDto {
  final int size;
  @JsonKey(includeIfNull: false)
  final List<List<GameSummaryCellDto>>? matrix;

  const GameSummaryBoardDto({required this.size, this.matrix});

  factory GameSummaryBoardDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryBoardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryBoardDtoToJson(this);
}

@JsonSerializable()
class GameSummaryCellDto {
  @JsonKey(name: 'tile')
  final GameSummaryTileDto tileData;

  @JsonKey(name: 'item')
  final GameSummaryItemDto? itemData;

  const GameSummaryCellDto({
    required this.tileData,
    this.itemData,
  });

  factory GameSummaryCellDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryCellDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryCellDtoToJson(this);

  String get tileType => tileData.type;
  String? get tileState => tileData.state;
  String? get tileOrientation => tileData.orientation;
  String? get itemType => itemData?.type;
}

@JsonSerializable()
class GameSummaryTileDto {
  final String type;
  final String? orientation;
  final String? state;

  const GameSummaryTileDto({
    required this.type,
    this.orientation,
    this.state,
  });

  factory GameSummaryTileDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryTileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryTileDtoToJson(this);
}

@JsonSerializable()
class GameSummaryItemDto {
  final String type;

  const GameSummaryItemDto({required this.type});

  factory GameSummaryItemDto.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameSummaryItemDtoToJson(this);
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


