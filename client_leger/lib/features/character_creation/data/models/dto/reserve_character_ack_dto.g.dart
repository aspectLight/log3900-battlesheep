// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve_character_ack_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveCharacterAckDto _$ReserveCharacterAckDtoFromJson(
  Map<String, dynamic> json,
) => ReserveCharacterAckDto(
  success: json['success'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$ReserveCharacterAckDtoToJson(
  ReserveCharacterAckDto instance,
) => <String, dynamic>{'success': instance.success, 'error': instance.error};
