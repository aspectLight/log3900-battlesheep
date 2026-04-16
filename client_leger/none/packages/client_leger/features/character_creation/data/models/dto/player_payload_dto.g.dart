// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerPayloadDto _$PlayerPayloadDtoFromJson(Map<String, dynamic> json) =>
    PlayerPayloadDto(
      name: json['name'] as String,
      avatar: AvatarNameDto.fromJson(json['avatar'] as Map<String, dynamic>),
      bonusChoice: json['bonusChoice'] as String,
      d6Choice: json['d6Choice'] as String,
      d4Choice: json['d4Choice'] as String,
      inventory: (json['inventory'] as List<dynamic>)
          .map(
            (e) => PlayerInventoryItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      stats: (json['stats'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PlayerStatValueDto.fromJson(e as Map<String, dynamic>)),
      ),
      activeBanner: json['activeBanner'] as String?,
    );

Map<String, dynamic> _$PlayerPayloadDtoToJson(PlayerPayloadDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar.toJson(),
      'bonusChoice': instance.bonusChoice,
      'd6Choice': instance.d6Choice,
      'd4Choice': instance.d4Choice,
      'inventory': instance.inventory.map((e) => e.toJson()).toList(),
      'stats': instance.stats.map((k, e) => MapEntry(k, e.toJson())),
      if (instance.activeBanner case final value?) 'activeBanner': value,
    };

PlayerInventoryItemDto _$PlayerInventoryItemDtoFromJson(
  Map<String, dynamic> json,
) => PlayerInventoryItemDto(type: json['type'] as String);

Map<String, dynamic> _$PlayerInventoryItemDtoToJson(
  PlayerInventoryItemDto instance,
) => <String, dynamic>{'type': instance.type};
