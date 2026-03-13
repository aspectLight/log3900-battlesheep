import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_character_submit_state.freezed.dart';

@freezed
sealed class CreateCharacterSubmitState with _$CreateCharacterSubmitState {
  const factory CreateCharacterSubmitState.initial() =
      CreateCharacterSubmitStateInitial;

  const factory CreateCharacterSubmitState.submitting() =
      CreateCharacterSubmitStateSubmitting;

  const factory CreateCharacterSubmitState.success() =
      CreateCharacterSubmitStateSuccess;
}
