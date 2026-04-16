// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDto _$ReservationDtoFromJson(Map<String, dynamic> json) =>
    ReservationDto(
      character: const ChosenAvatarCharacterConverter().fromJson(
        json['chosenAvatar'] as String,
      ),
      playerId: json['reservorId'] as String,
    );

Map<String, dynamic> _$ReservationDtoToJson(ReservationDto instance) =>
    <String, dynamic>{
      'chosenAvatar': const ChosenAvatarCharacterConverter().toJson(
        instance.character,
      ),
      'reservorId': instance.playerId,
    };
