// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDto _$GameDtoFromJson(Map<String, dynamic> json) => GameDto(
  id: json['_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  mode: json['mode'] as String,
  board: BoardDto.fromJson(json['board'] as Map<String, dynamic>),
  privacy: json['privacy'] as String,
  owner: json['owner'] as String,
  actionPoints: (json['actionPoints'] as num?)?.toInt() ?? 1,
  modificationDate: json['modificationDate'] as String,
);

Map<String, dynamic> _$GameDtoToJson(GameDto instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'mode': instance.mode,
  'board': instance.board.toJson(),
  'privacy': instance.privacy,
  'owner': instance.owner,
  'actionPoints': instance.actionPoints,
  'modificationDate': instance.modificationDate,
};

BoardDto _$BoardDtoFromJson(Map<String, dynamic> json) => BoardDto(
  size: (json['size'] as num).toInt(),
  matrix: (json['matrix'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>)
            .map((e) => CellDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      .toList(),
);

Map<String, dynamic> _$BoardDtoToJson(BoardDto instance) => <String, dynamic>{
  'size': instance.size,
  'matrix': instance.matrix
      .map((e) => e.map((e) => e.toJson()).toList())
      .toList(),
};

CellDto _$CellDtoFromJson(Map<String, dynamic> json) => CellDto(
  tileData: TileDataDto.fromJson(json['tile'] as Map<String, dynamic>),
  itemData: json['item'] == null
      ? null
      : ItemDataDto.fromJson(json['item'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CellDtoToJson(CellDto instance) => <String, dynamic>{
  'tile': instance.tileData,
  'item': instance.itemData,
};

TileDataDto _$TileDataDtoFromJson(Map<String, dynamic> json) => TileDataDto(
  type: const TileTypeConverter().fromJson(json['type'] as String),
  state: const TileStateConverter().fromJson(json['state'] as String?),
  orientation: const TileOrientationConverter().fromJson(
    json['orientation'] as String?,
  ),
);

Map<String, dynamic> _$TileDataDtoToJson(
  TileDataDto instance,
) => <String, dynamic>{
  'type': const TileTypeConverter().toJson(instance.type),
  'state': const TileStateConverter().toJson(instance.state),
  'orientation': const TileOrientationConverter().toJson(instance.orientation),
};

ItemDataDto _$ItemDataDtoFromJson(Map<String, dynamic> json) =>
    ItemDataDto(type: $enumDecode(_$ItemTypeEnumMap, json['type']));

Map<String, dynamic> _$ItemDataDtoToJson(ItemDataDto instance) =>
    <String, dynamic>{'type': _$ItemTypeEnumMap[instance.type]!};

const _$ItemTypeEnumMap = {
  ItemType.adrenaline: 'adrenaline',
  ItemType.vodka: 'vodka',
  ItemType.propaganda: 'propaganda',
  ItemType.barbedWire: 'barbedWire',
  ItemType.camouflage: 'camouflage',
  ItemType.waterproofBoots: 'waterproofBoots',
  ItemType.airStrike: 'airStrike',
  ItemType.random: 'random',
  ItemType.flag: 'flag',
  ItemType.spawnPoint: 'spawnPoint',
};
