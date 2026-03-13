// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSummaryBoardDto _$GameSummaryBoardDtoFromJson(Map<String, dynamic> json) =>
    GameSummaryBoardDto(size: (json['size'] as num).toInt());

Map<String, dynamic> _$GameSummaryBoardDtoToJson(
  GameSummaryBoardDto instance,
) => <String, dynamic>{'size': instance.size};

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
