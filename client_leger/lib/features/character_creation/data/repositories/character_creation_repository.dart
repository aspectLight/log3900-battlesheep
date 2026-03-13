import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/exceptions/reserve_character_failure.dart';
import '../../domain/commands/create_character_commands.dart';
import '../../domain/commands/get_reserved_characters_command.dart';
import '../../domain/commands/reserve_character_command.dart';
import 'dart:async';

import '../../domain/events/character_creation_events.dart';
import '../../domain/state/character_creation_state.dart';
import '../services/character_creation_socket.dart';

class CharacterCreationRepository {
  CharacterCreationRepository({
    required CharacterCreationSocket socket,
    required String roomCode,
  }) : _socket = socket,
       state = signal(CharacterCreationState.initial(roomId: roomCode));

  final CharacterCreationSocket _socket;

  String get roomCode => state.value.roomId;

  final Signal<CharacterCreationState> state;

  void setName(String value) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(name: value),
    );
  }

  void setSelectedCharacterId(Option<String> id) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(selectedCharacterId: id),
    );
  }

  void setHealth(int value) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(health: value),
    );
  }

  void setSpeed(int value) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(speed: value),
    );
  }

  void setAttackDice(int value) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(attackDice: value),
    );
  }

  void setDefenseDice(int value) {
    state.value = state.value.copyWith(
      form: state.value.form.copyWith(defenseDice: value),
    );
  }

  void applyRoomLocked({required bool value}) {
    state.value = state.value.copyWith(roomLocked: value);
  }

  void applyReservedCharacters(List<ReservedCharacterEvent> value) {
    state.value = state.value.copyWith(reservedCharacters: value);
  }

  void loadReservedCharacters() {
    unawaited(
      _socket
          .fetchReservedCharacters(
            GetReservedCharactersCommand(roomId: state.value.roomId),
          )
          .then(applyReservedCharacters),
    );
  }

  Future<String> generateRoomCode() {
    return _socket.generateRoomCode();
  }

  Future<Either<ReserveCharacterFailure, void>> reserveCharacter(
    ReserveCharacterCommand command,
  ) => _socket.reserveCharacter(
    ReserveCharacterCommand(
      roomId: state.value.roomId,
      chosenAvatar: command.chosenAvatar,
      playerId: command.playerId,
    ),
  );

  void submitCharacter(CreateCharacterCommand command) {
    _socket.submitCharacter(
      CreateCharacterCommand(
        roomId: state.value.roomId,
        player: command.player,
      ),
    );
  }

  void createWaitingRoom({required CreateWaitingRoomCommand command}) {
    _socket.createWaitingRoom(command: command);
  }
}
