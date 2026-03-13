import 'package:freezed_annotation/freezed_annotation.dart';

import '../events/character_creation_events.dart';
import '../models/character_creation_form.dart';

part 'character_creation_state.freezed.dart';

@freezed
class CharacterCreationState with _$CharacterCreationState {
  const factory CharacterCreationState({
    required String roomId,
    required CharacterCreationForm form,
    required bool roomLocked,
    @Default([]) List<ReservedCharacterEvent> reservedCharacters,
  }) = _CharacterCreationState;

  const CharacterCreationState._();

  factory CharacterCreationState.initial({required String roomId}) =>
      CharacterCreationState(
        roomId: roomId,
        form: CharacterCreationForm.initial(),
        roomLocked: false,
      );
}
