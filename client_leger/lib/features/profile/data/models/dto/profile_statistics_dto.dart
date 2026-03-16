import 'package:json_annotation/json_annotation.dart';

part 'profile_statistics_dto.g.dart';

@JsonSerializable()
class ProfileStatisticsDto {
  final int classicGamesPlayed;
  final int ctfGamesPlayed;
  final int totalGamesWon;
  final int averagePlaytimePerGame;

  const ProfileStatisticsDto({
    required this.classicGamesPlayed,
    required this.ctfGamesPlayed,
    required this.totalGamesWon,
    required this.averagePlaytimePerGame,
  });

  factory ProfileStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatisticsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileStatisticsDtoToJson(this);
}

