// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_room_command_ack_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitingRoomCommandAckDto _$WaitingRoomCommandAckDtoFromJson(
  Map<String, dynamic> json,
) => WaitingRoomCommandAckDto(
  success: json['success'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$WaitingRoomCommandAckDtoToJson(
  WaitingRoomCommandAckDto instance,
) => <String, dynamic>{'success': instance.success, 'error': instance.error};
