import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/character.dart';

part 'reservation_model.freezed.dart';

@freezed
class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
    required Character character,
    required String playerId,
  }) = _ReservationModel;
}
