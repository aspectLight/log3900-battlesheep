import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'character_creation_form.freezed.dart';

@freezed
class CharacterCreationForm with _$CharacterCreationForm {
  const factory CharacterCreationForm({
    @Default('') String name,
    @Default(Option.none()) Option<String> selectedCharacterId,
    @Default(4) int health,
    @Default(4) int speed,
    @Default(4) int attackDice,
    @Default(6) int defenseDice,
  }) = _CharacterCreationForm;

  factory CharacterCreationForm.initial() => const CharacterCreationForm();
}
