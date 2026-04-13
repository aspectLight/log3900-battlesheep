import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/enums/character.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../../../core/notification/notification_intent_sink.dart';
import '../../../../join_game_session/core/exceptions/join_game_session_failure.dart';
import '../../../core/app_events/character_creation_events.dart';
import '../../../core/constants/character_creation_constants.dart';
import '../../../core/event_bus/character_creation_event_bus.dart';
import '../../../core/helpers/character_creation_form_validator.dart';
import '../../../data/repositories/character_creation_repository.dart';
import '../../../domain/models/character_creation_entry_mode.dart';
import '../../../domain/state/character_creation_state.dart';
import '../../../domain/use_cases/create_character_use_case.dart';
import '../../../domain/use_cases/reserve_character_use_case.dart';
import '../../mappers/character_creation_form_to_command_mapper.dart';
import '../../ui_models/widget_states/create_character_submit_state.dart';

class CharacterCreationViewModel {
  CharacterCreationViewModel({
    required CreateCharacterUseCase createCharacterUseCase,
    required ReserveCharacterUseCase reserveCharacterUseCase,
    required CharacterCreationRepository repository,
    required NotificationIntentSink notificationIntentSink,
    required CharacterCreationEventBus eventBus,
    required AppTransitionEventBus appTransitionEventBus,
    required String socketId,
    required CharacterCreationEntryMode entryMode,
    required String username,
  }) : _createCharacterUseCase = createCharacterUseCase,
       _reserveCharacterUseCase = reserveCharacterUseCase,
       _repository = repository,
       _notificationIntentSink = notificationIntentSink,
       _eventBus = eventBus,
       _appTransitionEventBus = appTransitionEventBus,
       _socketId = socketId,
       _entryMode = entryMode,
       _username = username;

  final CreateCharacterUseCase _createCharacterUseCase;
  final ReserveCharacterUseCase _reserveCharacterUseCase;
  final CharacterCreationRepository _repository;
  final NotificationIntentSink _notificationIntentSink;
  final CharacterCreationEventBus _eventBus;
  final AppTransitionEventBus _appTransitionEventBus;
  final String _socketId;
  final CharacterCreationEntryMode _entryMode;
  final String _username;

  final createSubmitState = signal<CreateCharacterSubmitState>(
    const CreateCharacterSubmitState.initial(),
  );

  Signal<CharacterCreationState> get creationState => _repository.state;

  late final form = computed(() => _repository.state.value.form);

  late final roomLocked = computed(() => _repository.state.value.roomLocked);

  late final reservedCharacters = computed(
    () => _repository.state.value.reservedCharacters,
  );

  late final previewHealth = computed(
    () => _repository.state.value.form.health,
  );
  late final previewSpeed = computed(() => _repository.state.value.form.speed);
  late final previewAttack = computed(
    () => _repository.state.value.form.attackDice,
  );
  late final previewDefense = computed(
    () => _repository.state.value.form.defenseDice,
  );

  late final hasSelectedDice = computed(() {
    return CharacterCreationFormValidator.hasValidDicePairing(
      _repository.state.value.form,
    );
  });

  bool get isSubmitting =>
      createSubmitState.value is CreateCharacterSubmitStateSubmitting;
  bool get isHost => _entryMode is CharacterCreationHostEntryMode;
  bool get isDropIn => switch (_entryMode) {
        CharacterCreationJoinEntryMode(:final isDropIn) => isDropIn,
        _ => false,
      };
  String get username => _username;

  List<Character> get charactersForGrid => Character.values;

  void requestExitToCreateGame() {
    _appTransitionEventBus.fire(
      const CharacterCreationExitAppEvent.exitRequested(),
    );
  }

  void init() {
    _repository.setName(_username);
    final form = _repository.state.value.form;
    if (!CharacterCreationFormValidator.hasValidDicePairing(form)) {
      selectAttackDice(CharacterCreationConstants.d4Value);
    }
  }

  void selectCharacter(Character character) {
    if (isCharacterDisabled(character)) return;
    _repository.setSelectedCharacterId(Option.of(character.id));
    if (isHost) return;
    // In drop-in (game already started), the waiting room may not exist.
    // Avoid calling `reserveAvatar` to prevent server errors.
    if (isDropIn) return;
    unawaited(_reserveSelectedCharacter(character.id));
  }

  bool isCharacterDisabled(Character character) {
    return _repository.state.value.reservedCharacters.any(
      (reservedCharacter) =>
          reservedCharacter.chosenAvatar.toLowerCase() == character.id &&
          reservedCharacter.reservorId != _socketId,
    );
  }

  void selectHealthBonus() {
    _repository.setHealthAndSpeed(
      health: CharacterCreationConstants.statWithBonusValue,
      speed: CharacterCreationConstants.defaultStatValue,
    );
  }

  void selectSpeedBonus() {
    _repository.setHealthAndSpeed(
      health: CharacterCreationConstants.defaultStatValue,
      speed: CharacterCreationConstants.statWithBonusValue,
    );
  }

  void selectAttackDice(int sides) {
    _applyDiceSelection(isAttack: true, sides: sides);
  }

  void selectDefenseDice(int sides) {
    _applyDiceSelection(isAttack: false, sides: sides);
  }

  Future<void> submitCharacter() async {
    final form = this.form.value;
    final errors = CharacterCreationFormValidator.validateAll(form);
    if (errors.isNotEmpty) {
      _notificationIntentSink.addIntent(
        CharacterCreationValidationNotificationIntent(errors.first),
      );
      return;
    }
    if (isSubmitting) return;
    createSubmitState.value = const CreateCharacterSubmitState.submitting();
    final command = toCommand(form, _repository.roomCode);
    try {
      await _createCharacterUseCase.execute(command);
    } on JoinGameSessionFailure catch (failure) {
      _notificationIntentSink.addIntent(
        JoinGameSessionFailureNotificationIntent(failure),
      );
    }
    createSubmitState.value = const CreateCharacterSubmitState.initial();
  }

  void _applyDiceSelection({required bool isAttack, required int sides}) {
    if (!CharacterCreationFormValidator.isValidDiceValue(sides)) return;
    final opposite = sides == CharacterCreationConstants.d4Value
        ? CharacterCreationConstants.d6Value
        : CharacterCreationConstants.d4Value;
    if (isAttack) {
      _repository.setAttackDice(sides);
      _repository.setDefenseDice(opposite);
      return;
    }
    _repository.setDefenseDice(sides);
    _repository.setAttackDice(opposite);
  }

  Future<void> _reserveSelectedCharacter(String characterId) async {
    final result = await _reserveCharacterUseCase.execute(characterId);
    result.when(
      left: (failure) =>
          _eventBus.fire(CharacterCreationReserveFailedEvent(failure)),
    );
  }

  void dispose() {}
}
