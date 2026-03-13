import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/enums/item_type.dart';
import 'game_board_position_dto.dart';

part 'game_item_dto.g.dart';

class _ItemTypeConverter implements JsonConverter<ItemType, String> {
  const _ItemTypeConverter();

  @override
  ItemType fromJson(String json) =>
      ItemType.values.firstWhere((e) => e.name == json);

  @override
  String toJson(ItemType object) => object.name;
}

@JsonSerializable()
class GameItemDto {
  @_ItemTypeConverter()
  final ItemType type;

  const GameItemDto({required this.type});

  factory GameItemDto.fromJson(Map<String, dynamic> json) =>
      _$GameItemDtoFromJson(json);

  factory GameItemDto.fromDynamic(dynamic value) =>
      GameItemDto.fromJson(value as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$GameItemDtoToJson(this);
}

@JsonSerializable()
class ItemDroppedCommandDto {
  final String roomId;
  final String? playerId;
  final GameItemDto item;
  final GameBoardPositionDto coords;

  const ItemDroppedCommandDto({
    required this.roomId,
    required this.playerId,
    required this.item,
    required this.coords,
  });

  factory ItemDroppedCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDroppedCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDroppedCommandDtoToJson(this);
}

@JsonSerializable()
class ItemCollectedCommandDto {
  final String roomId;
  final String playerId;
  final GameItemDto item;
  final GameBoardPositionDto position;

  const ItemCollectedCommandDto({
    required this.roomId,
    required this.playerId,
    required this.item,
    required this.position,
  });

  factory ItemCollectedCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ItemCollectedCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemCollectedCommandDtoToJson(this);
}

@JsonSerializable()
class ItemCollectedDto {
  final String playerId;
  final GameItemDto item;

  const ItemCollectedDto({required this.playerId, required this.item});

  factory ItemCollectedDto.fromJson(Map<String, dynamic> json) =>
      _$ItemCollectedDtoFromJson(json);

  factory ItemCollectedDto.fromObject(dynamic data) =>
      ItemCollectedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ItemCollectedDtoToJson(this);
}

@JsonSerializable()
class ItemDroppedDto {
  final String roomId;
  final String playerId;
  final GameItemDto item;
  final GameBoardPositionDto coords;

  const ItemDroppedDto({
    required this.roomId,
    required this.playerId,
    required this.item,
    required this.coords,
  });

  factory ItemDroppedDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDroppedDtoFromJson(json);

  factory ItemDroppedDto.fromObject(dynamic data) =>
      ItemDroppedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ItemDroppedDtoToJson(this);
}

@JsonSerializable()
class ItemDroppedDisconnectedDto {
  final List<GameItemDto> items;
  final GameBoardPositionDto coords;
  final String roomId;

  const ItemDroppedDisconnectedDto({
    required this.items,
    required this.coords,
    required this.roomId,
  });

  factory ItemDroppedDisconnectedDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDroppedDisconnectedDtoFromJson(json);

  factory ItemDroppedDisconnectedDto.fromObject(dynamic data) =>
      ItemDroppedDisconnectedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ItemDroppedDisconnectedDtoToJson(this);
}

class FlagCollectedDto {
  final String playerId;

  const FlagCollectedDto({required this.playerId});

  factory FlagCollectedDto.fromObject(dynamic data) =>
      FlagCollectedDto(playerId: data as String);
}
