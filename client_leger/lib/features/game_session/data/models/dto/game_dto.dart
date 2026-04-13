import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/item_type_converter.dart';
import '../../../../../core/converters/tile_converters.dart';
import '../../../../../core/enums/item_type.dart';
import '../../../core/enums/tile_orientation.dart';
import '../../../core/enums/tile_type.dart';

part 'game_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GameDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  final String mode;
  final BoardDto board;
  final String privacy;
  final String owner;
  @JsonKey(defaultValue: 1)
  final int actionPoints;
  final String modificationDate;

  const GameDto({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.board,
    required this.privacy,
    required this.owner,
    required this.actionPoints,
    required this.modificationDate,
  });

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BoardDto {
  final int size;
  final List<List<CellDto>> matrix;

  const BoardDto({required this.size, required this.matrix});

  factory BoardDto.fromJson(Map<String, dynamic> json) =>
      _$BoardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BoardDtoToJson(this);
}

@JsonSerializable()
class CellDto {
  @JsonKey(name: 'tile')
  final TileDataDto tileData;
  @JsonKey(name: 'item')
  final ItemDataDto? itemData;

  const CellDto({required this.tileData, this.itemData});

  factory CellDto.fromJson(Map<String, dynamic> json) =>
      _$CellDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CellDtoToJson(this);

  TileType get tileType => tileData.type;
  String? get tileState => tileData.state;
  ItemType? get itemType => itemData?.type;
}

@JsonSerializable()
class TileDataDto {
  @TileTypeConverter()
  final TileType type;
  final String? state;
  @TileOrientationConverter()
  final TileOrientation? orientation;

  const TileDataDto({required this.type, this.state, this.orientation});

  factory TileDataDto.fromJson(Map<String, dynamic> json) =>
      _$TileDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TileDataDtoToJson(this);
}

@JsonSerializable()
class ItemDataDto {
  @ItemTypeConverter()
  final ItemType type;

  const ItemDataDto({required this.type});

  factory ItemDataDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDataDtoToJson(this);
}
