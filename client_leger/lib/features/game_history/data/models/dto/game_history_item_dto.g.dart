// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameHistoryItemDto _$GameHistoryItemDtoFromJson(Map<String, dynamic> json) =>
    GameHistoryItemDto(
      startDate: json['startDate'] as String,
      mode: json['mode'] as String,
      hasWon: json['hasWon'] as bool,
      hasAbandoned: json['hasAbandoned'] as bool,
    );

Map<String, dynamic> _$GameHistoryItemDtoToJson(GameHistoryItemDto instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'mode': instance.mode,
      'hasWon': instance.hasWon,
      'hasAbandoned': instance.hasAbandoned,
    };
