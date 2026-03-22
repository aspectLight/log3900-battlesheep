// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSummaryBoardDto _$GameSummaryBoardDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryBoardDto(
      size: (json['size'] as num).toInt(),
      matrix: (json['matrix'] as List<dynamic>?)
          ?.map(
            (e) => (e as List<dynamic>)
                .map(
                  (e) => GameSummaryCellDto.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          )
          .toList(),
    );

Map<String, dynamic> _$GameSummaryBoardDtoToJson(
  GameSummaryBoardDto instance,
) => <String, dynamic>{
  'size': instance.size,
  if (instance.matrix case final value?) 'matrix': value,
};

GameSummaryCellDto _$GameSummaryCellDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryCellDto(
      tileData: GameSummaryTileDto.fromJson(
        json['tile'] as Map<String, dynamic>,
      ),
      itemData: json['item'] == null
          ? null
          : GameSummaryItemDto.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameSummaryCellDtoToJson(GameSummaryCellDto instance) =>
    <String, dynamic>{'tile': instance.tileData, 'item': instance.itemData};

GameSummaryTileDto _$GameSummaryTileDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryTileDto(
      type: json['type'] as String,
      orientation: json['orientation'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$GameSummaryTileDtoToJson(GameSummaryTileDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'orientation': instance.orientation,
      'state': instance.state,
    };

GameSummaryItemDto _$GameSummaryItemDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryItemDto(type: json['type'] as String);

Map<String, dynamic> _$GameSummaryItemDtoToJson(GameSummaryItemDto instance) =>
    <String, dynamic>{'type': instance.type};

GameSummaryDto _$GameSummaryDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      mode: const GameModeConverter().fromJson(json['mode'] as String),
      board: GameSummaryBoardDto.fromJson(
        json['board'] as Map<String, dynamic>,
      ),
      isVisible: json['isVisible'] as bool,
      modificationDate: json['modificationDate'] as String,
    );

Map<String, dynamic> _$GameSummaryDtoToJson(GameSummaryDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'mode': const GameModeConverter().toJson(instance.mode),
      'board': instance.board,
      'isVisible': instance.isVisible,
      'modificationDate': instance.modificationDate,
    };
