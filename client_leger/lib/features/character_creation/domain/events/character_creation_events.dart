import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_creation_events.freezed.dart';

@freezed
class ReservedCharacterEvent with _$ReservedCharacterEvent {
  const factory ReservedCharacterEvent({
    required String reservorId,
    required String chosenAvatar,
  }) = _ReservedCharacterEvent;
}
