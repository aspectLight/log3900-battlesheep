import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/character.dart';
import '../../../../core/enums/dice_stat_choice.dart';
import '../../../../core/enums/virtual_player_type.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../core/constants/waiting_room_stat_constants.dart';
import '../../core/exceptions/waiting_room_failure.dart';
import '../commands/add_virtual_player_command.dart';
import '../commands/reserve_character_command.dart';
import '../models/waiting_room_player_model.dart';
import '../models/waiting_room_player_stats_model.dart';
import '../models/waiting_room_player_stat_value_model.dart';
import '../../data/repositories/waiting_room_reservations_repository.dart';
import '../../data/repositories/waiting_room_room_repository.dart';

class AddVirtualPlayerUseCase {
  AddVirtualPlayerUseCase({
    required WaitingRoomReservationsRepository reservationsRepository,
    required WaitingRoomRoomRepository roomRepository,
  }) : _reservationsRepository = reservationsRepository,
       _roomRepository = roomRepository;

  final WaitingRoomReservationsRepository _reservationsRepository;
  final WaitingRoomRoomRepository _roomRepository;
  static final _random = Random();
  bool _isAdding = false;
  final Set<String> _pendingNames = <String>{};
  final Set<Character> _pendingCharacters = <Character>{};
  static const List<String> _virtualPlayerNames = [
    'VP1',
    'VP2',
    'VP3',
    'VP4',
    'VP5',
    'VP6',
    'VP7',
    'VP8',
    'VP9',
    'VP10',
  ];
  static const int _bonusStatValue = 6;

  Future<Either<WaitingRoomFailure, void>> execute({
    required VirtualPlayerType virtualType,
  }) async {
    if (_isAdding) return right(null);
    _isAdding = true;
    Character? pendingCharacter;
    String? pendingName;
    try {
      final roomId = _roomRepository.state.value.room.roomId;
      final characterOption = _allocateAvailableCharacter();
      if (characterOption.isNone()) {
        return left(const CharacterAlreadyReservedWaitingRoomFailure());
      }
      final nameOption = _allocateVirtualPlayerName();
      if (nameOption.isNone()) {
        return left(const VirtualPlayerNameUnavailableWaitingRoomFailure());
      }
      final character = characterOption.assumePresent();
      final name = nameOption.assumePresent();
      pendingCharacter = character;
      pendingName = name;
      _pendingCharacters.add(character);
      _pendingNames.add(name);
      final id = name;
      final stats = _randomVirtualPlayerStats();
      final (d6Choice, d4Choice) = _randomDiceChoices();
      final player = WaitingRoomPlayerModel.virtual(
        id: id,
        name: name,
        character: character,
        stats: stats,
        virtualType: virtualType,
        d6Choice: d6Choice,
        d4Choice: d4Choice,
      );
      final reserveResult = await _reservationsRepository.reserveCharacter(
        ReserveCharacterCommand(
          roomId: roomId,
          chosenCharacter: character,
          playerId: id,
          isVirtual: true,
        ),
      );
      return reserveResult.map((_) {
        _roomRepository.addVirtualPlayer(
          AddVirtualPlayerCommand(roomId: roomId, player: player),
        );
      });
    } finally {
      if (pendingCharacter != null) {
        _pendingCharacters.remove(pendingCharacter);
      }
      if (pendingName != null) {
        _pendingNames.remove(pendingName);
      }
      _isAdding = false;
    }
  }

  Option<String> _allocateVirtualPlayerName() {
    final usedNames = _roomRepository.state.value.room.players
        .map((player) => player.name)
        .followedBy(_pendingNames)
        .toSet();
    final availableNames = _virtualPlayerNames
        .where((name) => !usedNames.contains(name))
        .toList();
    if (availableNames.isEmpty) return none();
    return Option.of(availableNames[_random.nextInt(availableNames.length)]);
  }

  Option<Character> _allocateAvailableCharacter() {
    final reservedCharacters = _reservationsRepository.state.value.reservations
        .map((reservation) => reservation.character)
        .followedBy(_pendingCharacters)
        .toSet();
    final availableCharacters = Character.values
        .where((character) => !reservedCharacters.contains(character))
        .toList();
    if (availableCharacters.isEmpty) return none();
    return Option.of(
      availableCharacters[_random.nextInt(availableCharacters.length)],
    );
  }

  (DiceStatChoice, DiceStatChoice) _randomDiceChoices() {
    return _random.nextBool()
        ? (DiceStatChoice.attack, DiceStatChoice.defense)
        : (DiceStatChoice.defense, DiceStatChoice.attack);
  }

  WaitingRoomPlayerStatsModel _randomVirtualPlayerStats() {
    const baseStat = WaitingRoomPlayerStatValueModel(
      value: WaitingRoomStatConstants.defaultWaitingRoomStatValue,
      maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
    );
    const bonusStat = WaitingRoomPlayerStatValueModel(
      value: _bonusStatValue,
      maxValue: _bonusStatValue,
    );
    final bonusIsHealth = _random.nextBool();
    return WaitingRoomPlayerStatsModel(
      health: bonusIsHealth ? bonusStat : baseStat,
      speed: bonusIsHealth ? baseStat : bonusStat,
    );
  }
}
