import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/avatar_name_converter.dart';
import '../../../../../core/converters/stat_value_converter.dart';
import '../../../../../core/converters/virtual_player_type_converter.dart';
import '../../../../../core/enums/virtual_player_type.dart';

part 'join_room_response_dto.g.dart';

@JsonSerializable()
class JoinRoomPlayerStatsDto {
  const JoinRoomPlayerStatsDto({
    required this.health,
    required this.speed,
    required this.attack,
    required this.defense,
  });

  @StatValueConverter()
  final int health;
  @StatValueConverter()
  final int speed;
  @StatValueConverter()
  final int attack;
  @StatValueConverter()
  final int defense;

  factory JoinRoomPlayerStatsDto.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomPlayerStatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinRoomPlayerStatsDtoToJson(this);
}

@JsonSerializable()
class JoinRoomPlayerDto {
  const JoinRoomPlayerDto({
    required this.id,
    required this.name,
    required this.avatarName,
    required this.isVirtual,
    this.virtualType,
    required this.stats,
    this.activeBanner,
  });

  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(name: 'avatar')
  @AvatarNameConverter()
  final String avatarName;
  @JsonKey(defaultValue: false)
  final bool isVirtual;
  @JsonKey(name: 'profile')
  @VirtualPlayerTypeConverter()
  final VirtualPlayerType? virtualType;
  final JoinRoomPlayerStatsDto stats;
  final String? activeBanner;

  factory JoinRoomPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomPlayerDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinRoomPlayerDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JoinRoomDto {
  const JoinRoomDto({
    required this.roomId,
    required this.hostId,
    required this.players,
    required this.isLocked,
    required this.dropInDropOut,
    this.entryFee = 0,
    this.friendsOnly = false,
  });

  @JsonKey(name: 'roomId')
  final String roomId;
  final String hostId;
  final List<JoinRoomPlayerDto> players;
  final bool isLocked;
  @JsonKey(defaultValue: false)
  final bool dropInDropOut;
  @JsonKey(defaultValue: 0)
  final int entryFee;
  @JsonKey(defaultValue: false)
  final bool friendsOnly;

  factory JoinRoomDto.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinRoomDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JoinRoomResponseDto {
  const JoinRoomResponseDto({required this.success, this.error, this.room});

  final bool success;
  final String? error;
  final JoinRoomDto? room;

  factory JoinRoomResponseDto.fromJson(Map<String, dynamic> json) =>
      _$JoinRoomResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinRoomResponseDtoToJson(this);
}
