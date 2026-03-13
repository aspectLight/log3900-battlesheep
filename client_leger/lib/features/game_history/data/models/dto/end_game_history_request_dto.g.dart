// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_game_history_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndGameHistoryRequestDto _$EndGameHistoryRequestDtoFromJson(
  Map<String, dynamic> json,
) => EndGameHistoryRequestDto(
  startDate: json['startDate'] as String,
  hasWon: json['hasWon'] as bool,
);

Map<String, dynamic> _$EndGameHistoryRequestDtoToJson(
  EndGameHistoryRequestDto instance,
) => <String, dynamic>{
  'startDate': instance.startDate,
  'hasWon': instance.hasWon,
};
