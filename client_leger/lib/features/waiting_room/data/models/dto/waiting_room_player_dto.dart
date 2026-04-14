import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/dice_stat_choice_converter.dart';
import '../../../../../core/converters/safe_avatar_payload_converter.dart';
import '../../../../../core/converters/virtual_player_type_converter.dart';
import '../../../../../core/enums/dice_stat_choice.dart';
import '../../../../../core/enums/virtual_player_type.dart';
import 'waiting_room_player_stats_dto.dart';

part 'waiting_room_player_dto.g.dart';

@JsonSerializable()
class WaitingRoomPlayerDto {
  final String id;
  final String name;
  @JsonKey(name: 'avatar')
  @SafeAvatarPayloadConverter()
  final Map<String, dynamic>? avatar;
  @JsonKey(name: 'isVirtual')
  final bool isVirtual;
  @JsonKey(name: 'profile')
  @VirtualPlayerTypeConverter()
  final VirtualPlayerType virtualType;
  final WaitingRoomPlayerStatsDto stats;
  @JsonKey(name: 'd6Choice')
  @DiceStatChoiceConverter()
  final DiceStatChoice? d6Choice;
  @JsonKey(name: 'd4Choice')
  @DiceStatChoiceConverter()
  final DiceStatChoice? d4Choice;
  @JsonKey(name: 'profileAvatarId')
  final String? profileAvatarId;
  @JsonKey(name: 'profileAvatarUrl')
  final String? profileAvatarUrl;
  final String? activeBanner;

  const WaitingRoomPlayerDto({
    required this.id,
    required this.name,
    this.avatar,
    required this.stats,
    this.isVirtual = false,
    this.virtualType = VirtualPlayerType.aggressive,
    this.d6Choice,
    this.d4Choice,
    this.profileAvatarId,
    this.profileAvatarUrl,
    this.activeBanner,
  });

  factory WaitingRoomPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$WaitingRoomPlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingRoomPlayerDtoToJson(this);
}
