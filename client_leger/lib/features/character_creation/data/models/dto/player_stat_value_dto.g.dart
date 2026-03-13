// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stat_value_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStatValueDto _$PlayerStatValueDtoFromJson(Map<String, dynamic> json) =>
    PlayerStatValueDto(
      value: (json['value'] as num).toInt(),
      maxValue: (json['maxValue'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$PlayerStatValueDtoToJson(PlayerStatValueDto instance) =>
    <String, dynamic>{
      'value': instance.value,
      'maxValue': instance.maxValue,
      'description': instance.description,
    };
