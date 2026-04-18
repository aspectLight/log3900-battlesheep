// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitingRoomDto _$WaitingRoomDtoFromJson(Map<String, dynamic> json) =>
    WaitingRoomDto(
      roomId: json['roomId'] as String,
      hostId: json['hostId'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => WaitingRoomPlayerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLocked: json['isLocked'] as bool,
      dropInDropOut: json['dropInDropOut'] as bool? ?? false,
      entryFee: (json['entryFee'] as num?)?.toInt() ?? 0,
      friendsOnly: json['friendsOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$WaitingRoomDtoToJson(WaitingRoomDto instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'hostId': instance.hostId,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'isLocked': instance.isLocked,
      'dropInDropOut': instance.dropInDropOut,
      'entryFee': instance.entryFee,
      'friendsOnly': instance.friendsOnly,
    };
