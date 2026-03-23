// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameItemDto _$GameItemDtoFromJson(Map<String, dynamic> json) => GameItemDto(
  type: const _ItemTypeConverter().fromJson(json['type'] as String),
);

Map<String, dynamic> _$GameItemDtoToJson(GameItemDto instance) =>
    <String, dynamic>{'type': const _ItemTypeConverter().toJson(instance.type)};

ItemDroppedCommandDto _$ItemDroppedCommandDtoFromJson(
  Map<String, dynamic> json,
) => ItemDroppedCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String?,
  item: GameItemDto.fromJson(json['item'] as Map<String, dynamic>),
  coords: GameBoardPositionDto.fromJson(json['coords'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ItemDroppedCommandDtoToJson(
  ItemDroppedCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'item': instance.item,
  'coords': instance.coords,
};

ItemCollectedCommandDto _$ItemCollectedCommandDtoFromJson(
  Map<String, dynamic> json,
) => ItemCollectedCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  item: GameItemDto.fromJson(json['item'] as Map<String, dynamic>),
  position: GameBoardPositionDto.fromJson(
    json['position'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ItemCollectedCommandDtoToJson(
  ItemCollectedCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'item': instance.item,
  'position': instance.position,
};

ItemCollectedDto _$ItemCollectedDtoFromJson(Map<String, dynamic> json) =>
    ItemCollectedDto(
      playerId: json['playerId'] as String,
      item: GameItemDto.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemCollectedDtoToJson(ItemCollectedDto instance) =>
    <String, dynamic>{'playerId': instance.playerId, 'item': instance.item};

ItemDroppedDto _$ItemDroppedDtoFromJson(Map<String, dynamic> json) =>
    ItemDroppedDto(
      roomId: json['roomId'] as String,
      playerId: json['playerId'] as String?,
      item: GameItemDto.fromJson(json['item'] as Map<String, dynamic>),
      coords: GameBoardPositionDto.fromJson(
        json['coords'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ItemDroppedDtoToJson(ItemDroppedDto instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'playerId': instance.playerId,
      'item': instance.item,
      'coords': instance.coords,
    };

ItemDroppedDisconnectedDto _$ItemDroppedDisconnectedDtoFromJson(
  Map<String, dynamic> json,
) => ItemDroppedDisconnectedDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => GameItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  coords: GameBoardPositionDto.fromJson(json['coords'] as Map<String, dynamic>),
  roomId: json['roomId'] as String,
);

Map<String, dynamic> _$ItemDroppedDisconnectedDtoToJson(
  ItemDroppedDisconnectedDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'coords': instance.coords,
  'roomId': instance.roomId,
};
