// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_statistics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileStatisticsDto _$ProfileStatisticsDtoFromJson(
  Map<String, dynamic> json,
) => ProfileStatisticsDto(
  classicGamesPlayed: (json['classicGamesPlayed'] as num).toInt(),
  ctfGamesPlayed: (json['ctfGamesPlayed'] as num).toInt(),
  totalGamesWon: (json['totalGamesWon'] as num).toInt(),
  averagePlaytimePerGame: (json['averagePlaytimePerGame'] as num).toInt(),
);

Map<String, dynamic> _$ProfileStatisticsDtoToJson(
  ProfileStatisticsDto instance,
) => <String, dynamic>{
  'classicGamesPlayed': instance.classicGamesPlayed,
  'ctfGamesPlayed': instance.ctfGamesPlayed,
  'totalGamesWon': instance.totalGamesWon,
  'averagePlaytimePerGame': instance.averagePlaytimePerGame,
};
