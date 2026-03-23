// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpawnedPlayerEvent {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  BoardCharacterType get characterType => throw _privateConstructorUsedError;
  BoardCharacterColor get color => throw _privateConstructorUsedError;
  int get movementPoints => throw _privateConstructorUsedError;
  int get actionPoints => throw _privateConstructorUsedError;
  GameBoardPosition get spawnPoint => throw _privateConstructorUsedError;
  List<GameItem> get inventory => throw _privateConstructorUsedError;
  Map<StatType, int> get stats => throw _privateConstructorUsedError;
  StatType get diceChoice => throw _privateConstructorUsedError;
  bool get isVirtual => throw _privateConstructorUsedError;
  int get team => throw _privateConstructorUsedError;

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpawnedPlayerEventCopyWith<SpawnedPlayerEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpawnedPlayerEventCopyWith<$Res> {
  factory $SpawnedPlayerEventCopyWith(
    SpawnedPlayerEvent value,
    $Res Function(SpawnedPlayerEvent) then,
  ) = _$SpawnedPlayerEventCopyWithImpl<$Res, SpawnedPlayerEvent>;
  @useResult
  $Res call({
    String id,
    String name,
    BoardCharacterType characterType,
    BoardCharacterColor color,
    int movementPoints,
    int actionPoints,
    GameBoardPosition spawnPoint,
    List<GameItem> inventory,
    Map<StatType, int> stats,
    StatType diceChoice,
    bool isVirtual,
    int team,
  });

  $GameBoardPositionCopyWith<$Res> get spawnPoint;
}

/// @nodoc
class _$SpawnedPlayerEventCopyWithImpl<$Res, $Val extends SpawnedPlayerEvent>
    implements $SpawnedPlayerEventCopyWith<$Res> {
  _$SpawnedPlayerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? characterType = null,
    Object? color = null,
    Object? movementPoints = null,
    Object? actionPoints = null,
    Object? spawnPoint = null,
    Object? inventory = null,
    Object? stats = null,
    Object? diceChoice = null,
    Object? isVirtual = null,
    Object? team = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            characterType: null == characterType
                ? _value.characterType
                : characterType // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterType,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as BoardCharacterColor,
            movementPoints: null == movementPoints
                ? _value.movementPoints
                : movementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            actionPoints: null == actionPoints
                ? _value.actionPoints
                : actionPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            spawnPoint: null == spawnPoint
                ? _value.spawnPoint
                : spawnPoint // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
            inventory: null == inventory
                ? _value.inventory
                : inventory // ignore: cast_nullable_to_non_nullable
                      as List<GameItem>,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as Map<StatType, int>,
            diceChoice: null == diceChoice
                ? _value.diceChoice
                : diceChoice // ignore: cast_nullable_to_non_nullable
                      as StatType,
            isVirtual: null == isVirtual
                ? _value.isVirtual
                : isVirtual // ignore: cast_nullable_to_non_nullable
                      as bool,
            team: null == team
                ? _value.team
                : team // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get spawnPoint {
    return $GameBoardPositionCopyWith<$Res>(_value.spawnPoint, (value) {
      return _then(_value.copyWith(spawnPoint: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpawnedPlayerEventImplCopyWith<$Res>
    implements $SpawnedPlayerEventCopyWith<$Res> {
  factory _$$SpawnedPlayerEventImplCopyWith(
    _$SpawnedPlayerEventImpl value,
    $Res Function(_$SpawnedPlayerEventImpl) then,
  ) = __$$SpawnedPlayerEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    BoardCharacterType characterType,
    BoardCharacterColor color,
    int movementPoints,
    int actionPoints,
    GameBoardPosition spawnPoint,
    List<GameItem> inventory,
    Map<StatType, int> stats,
    StatType diceChoice,
    bool isVirtual,
    int team,
  });

  @override
  $GameBoardPositionCopyWith<$Res> get spawnPoint;
}

/// @nodoc
class __$$SpawnedPlayerEventImplCopyWithImpl<$Res>
    extends _$SpawnedPlayerEventCopyWithImpl<$Res, _$SpawnedPlayerEventImpl>
    implements _$$SpawnedPlayerEventImplCopyWith<$Res> {
  __$$SpawnedPlayerEventImplCopyWithImpl(
    _$SpawnedPlayerEventImpl _value,
    $Res Function(_$SpawnedPlayerEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? characterType = null,
    Object? color = null,
    Object? movementPoints = null,
    Object? actionPoints = null,
    Object? spawnPoint = null,
    Object? inventory = null,
    Object? stats = null,
    Object? diceChoice = null,
    Object? isVirtual = null,
    Object? team = null,
  }) {
    return _then(
      _$SpawnedPlayerEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        characterType: null == characterType
            ? _value.characterType
            : characterType // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterType,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as BoardCharacterColor,
        movementPoints: null == movementPoints
            ? _value.movementPoints
            : movementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        actionPoints: null == actionPoints
            ? _value.actionPoints
            : actionPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        spawnPoint: null == spawnPoint
            ? _value.spawnPoint
            : spawnPoint // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
        inventory: null == inventory
            ? _value._inventory
            : inventory // ignore: cast_nullable_to_non_nullable
                  as List<GameItem>,
        stats: null == stats
            ? _value._stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as Map<StatType, int>,
        diceChoice: null == diceChoice
            ? _value.diceChoice
            : diceChoice // ignore: cast_nullable_to_non_nullable
                  as StatType,
        isVirtual: null == isVirtual
            ? _value.isVirtual
            : isVirtual // ignore: cast_nullable_to_non_nullable
                  as bool,
        team: null == team
            ? _value.team
            : team // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SpawnedPlayerEventImpl implements _SpawnedPlayerEvent {
  const _$SpawnedPlayerEventImpl({
    required this.id,
    required this.name,
    required this.characterType,
    required this.color,
    required this.movementPoints,
    required this.actionPoints,
    required this.spawnPoint,
    final List<GameItem> inventory = const [],
    required final Map<StatType, int> stats,
    required this.diceChoice,
    this.isVirtual = false,
    required this.team,
  }) : _inventory = inventory,
       _stats = stats;

  @override
  final String id;
  @override
  final String name;
  @override
  final BoardCharacterType characterType;
  @override
  final BoardCharacterColor color;
  @override
  final int movementPoints;
  @override
  final int actionPoints;
  @override
  final GameBoardPosition spawnPoint;
  final List<GameItem> _inventory;
  @override
  @JsonKey()
  List<GameItem> get inventory {
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inventory);
  }

  final Map<StatType, int> _stats;
  @override
  Map<StatType, int> get stats {
    if (_stats is EqualUnmodifiableMapView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stats);
  }

  @override
  final StatType diceChoice;
  @override
  @JsonKey()
  final bool isVirtual;
  @override
  final int team;

  @override
  String toString() {
    return 'SpawnedPlayerEvent(id: $id, name: $name, characterType: $characterType, color: $color, movementPoints: $movementPoints, actionPoints: $actionPoints, spawnPoint: $spawnPoint, inventory: $inventory, stats: $stats, diceChoice: $diceChoice, isVirtual: $isVirtual, team: $team)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpawnedPlayerEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.characterType, characterType) ||
                other.characterType == characterType) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.movementPoints, movementPoints) ||
                other.movementPoints == movementPoints) &&
            (identical(other.actionPoints, actionPoints) ||
                other.actionPoints == actionPoints) &&
            (identical(other.spawnPoint, spawnPoint) ||
                other.spawnPoint == spawnPoint) &&
            const DeepCollectionEquality().equals(
              other._inventory,
              _inventory,
            ) &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            (identical(other.diceChoice, diceChoice) ||
                other.diceChoice == diceChoice) &&
            (identical(other.isVirtual, isVirtual) ||
                other.isVirtual == isVirtual) &&
            (identical(other.team, team) || other.team == team));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    characterType,
    color,
    movementPoints,
    actionPoints,
    spawnPoint,
    const DeepCollectionEquality().hash(_inventory),
    const DeepCollectionEquality().hash(_stats),
    diceChoice,
    isVirtual,
    team,
  );

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpawnedPlayerEventImplCopyWith<_$SpawnedPlayerEventImpl> get copyWith =>
      __$$SpawnedPlayerEventImplCopyWithImpl<_$SpawnedPlayerEventImpl>(
        this,
        _$identity,
      );
}

abstract class _SpawnedPlayerEvent implements SpawnedPlayerEvent {
  const factory _SpawnedPlayerEvent({
    required final String id,
    required final String name,
    required final BoardCharacterType characterType,
    required final BoardCharacterColor color,
    required final int movementPoints,
    required final int actionPoints,
    required final GameBoardPosition spawnPoint,
    final List<GameItem> inventory,
    required final Map<StatType, int> stats,
    required final StatType diceChoice,
    final bool isVirtual,
    required final int team,
  }) = _$SpawnedPlayerEventImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  BoardCharacterType get characterType;
  @override
  BoardCharacterColor get color;
  @override
  int get movementPoints;
  @override
  int get actionPoints;
  @override
  GameBoardPosition get spawnPoint;
  @override
  List<GameItem> get inventory;
  @override
  Map<StatType, int> get stats;
  @override
  StatType get diceChoice;
  @override
  bool get isVirtual;
  @override
  int get team;

  /// Create a copy of SpawnedPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpawnedPlayerEventImplCopyWith<_$SpawnedPlayerEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerSpawnedEvent {
  List<SpawnedPlayerEvent> get players => throw _privateConstructorUsedError;

  /// Create a copy of PlayerSpawnedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerSpawnedEventCopyWith<PlayerSpawnedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerSpawnedEventCopyWith<$Res> {
  factory $PlayerSpawnedEventCopyWith(
    PlayerSpawnedEvent value,
    $Res Function(PlayerSpawnedEvent) then,
  ) = _$PlayerSpawnedEventCopyWithImpl<$Res, PlayerSpawnedEvent>;
  @useResult
  $Res call({List<SpawnedPlayerEvent> players});
}

/// @nodoc
class _$PlayerSpawnedEventCopyWithImpl<$Res, $Val extends PlayerSpawnedEvent>
    implements $PlayerSpawnedEventCopyWith<$Res> {
  _$PlayerSpawnedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerSpawnedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<SpawnedPlayerEvent>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerSpawnedEventImplCopyWith<$Res>
    implements $PlayerSpawnedEventCopyWith<$Res> {
  factory _$$PlayerSpawnedEventImplCopyWith(
    _$PlayerSpawnedEventImpl value,
    $Res Function(_$PlayerSpawnedEventImpl) then,
  ) = __$$PlayerSpawnedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SpawnedPlayerEvent> players});
}

/// @nodoc
class __$$PlayerSpawnedEventImplCopyWithImpl<$Res>
    extends _$PlayerSpawnedEventCopyWithImpl<$Res, _$PlayerSpawnedEventImpl>
    implements _$$PlayerSpawnedEventImplCopyWith<$Res> {
  __$$PlayerSpawnedEventImplCopyWithImpl(
    _$PlayerSpawnedEventImpl _value,
    $Res Function(_$PlayerSpawnedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerSpawnedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _$PlayerSpawnedEventImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<SpawnedPlayerEvent>,
      ),
    );
  }
}

/// @nodoc

class _$PlayerSpawnedEventImpl implements _PlayerSpawnedEvent {
  const _$PlayerSpawnedEventImpl({
    required final List<SpawnedPlayerEvent> players,
  }) : _players = players;

  final List<SpawnedPlayerEvent> _players;
  @override
  List<SpawnedPlayerEvent> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'PlayerSpawnedEvent(players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerSpawnedEventImpl &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  /// Create a copy of PlayerSpawnedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerSpawnedEventImplCopyWith<_$PlayerSpawnedEventImpl> get copyWith =>
      __$$PlayerSpawnedEventImplCopyWithImpl<_$PlayerSpawnedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerSpawnedEvent implements PlayerSpawnedEvent {
  const factory _PlayerSpawnedEvent({
    required final List<SpawnedPlayerEvent> players,
  }) = _$PlayerSpawnedEventImpl;

  @override
  List<SpawnedPlayerEvent> get players;

  /// Create a copy of PlayerSpawnedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerSpawnedEventImplCopyWith<_$PlayerSpawnedEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TurnStartingEvent {
  String get nextPlayerId => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  int get nextPlayerMovementPoints => throw _privateConstructorUsedError;
  int get nextPlayerActionPoints => throw _privateConstructorUsedError;
  bool get isNextPlayerVirtual => throw _privateConstructorUsedError;

  /// Create a copy of TurnStartingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TurnStartingEventCopyWith<TurnStartingEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TurnStartingEventCopyWith<$Res> {
  factory $TurnStartingEventCopyWith(
    TurnStartingEvent value,
    $Res Function(TurnStartingEvent) then,
  ) = _$TurnStartingEventCopyWithImpl<$Res, TurnStartingEvent>;
  @useResult
  $Res call({
    String nextPlayerId,
    int startTime,
    int nextPlayerMovementPoints,
    int nextPlayerActionPoints,
    bool isNextPlayerVirtual,
  });
}

/// @nodoc
class _$TurnStartingEventCopyWithImpl<$Res, $Val extends TurnStartingEvent>
    implements $TurnStartingEventCopyWith<$Res> {
  _$TurnStartingEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TurnStartingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextPlayerId = null,
    Object? startTime = null,
    Object? nextPlayerMovementPoints = null,
    Object? nextPlayerActionPoints = null,
    Object? isNextPlayerVirtual = null,
  }) {
    return _then(
      _value.copyWith(
            nextPlayerId: null == nextPlayerId
                ? _value.nextPlayerId
                : nextPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as int,
            nextPlayerMovementPoints: null == nextPlayerMovementPoints
                ? _value.nextPlayerMovementPoints
                : nextPlayerMovementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            nextPlayerActionPoints: null == nextPlayerActionPoints
                ? _value.nextPlayerActionPoints
                : nextPlayerActionPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            isNextPlayerVirtual: null == isNextPlayerVirtual
                ? _value.isNextPlayerVirtual
                : isNextPlayerVirtual // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TurnStartingEventImplCopyWith<$Res>
    implements $TurnStartingEventCopyWith<$Res> {
  factory _$$TurnStartingEventImplCopyWith(
    _$TurnStartingEventImpl value,
    $Res Function(_$TurnStartingEventImpl) then,
  ) = __$$TurnStartingEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nextPlayerId,
    int startTime,
    int nextPlayerMovementPoints,
    int nextPlayerActionPoints,
    bool isNextPlayerVirtual,
  });
}

/// @nodoc
class __$$TurnStartingEventImplCopyWithImpl<$Res>
    extends _$TurnStartingEventCopyWithImpl<$Res, _$TurnStartingEventImpl>
    implements _$$TurnStartingEventImplCopyWith<$Res> {
  __$$TurnStartingEventImplCopyWithImpl(
    _$TurnStartingEventImpl _value,
    $Res Function(_$TurnStartingEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TurnStartingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextPlayerId = null,
    Object? startTime = null,
    Object? nextPlayerMovementPoints = null,
    Object? nextPlayerActionPoints = null,
    Object? isNextPlayerVirtual = null,
  }) {
    return _then(
      _$TurnStartingEventImpl(
        nextPlayerId: null == nextPlayerId
            ? _value.nextPlayerId
            : nextPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as int,
        nextPlayerMovementPoints: null == nextPlayerMovementPoints
            ? _value.nextPlayerMovementPoints
            : nextPlayerMovementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        nextPlayerActionPoints: null == nextPlayerActionPoints
            ? _value.nextPlayerActionPoints
            : nextPlayerActionPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        isNextPlayerVirtual: null == isNextPlayerVirtual
            ? _value.isNextPlayerVirtual
            : isNextPlayerVirtual // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$TurnStartingEventImpl extends _TurnStartingEvent {
  const _$TurnStartingEventImpl({
    required this.nextPlayerId,
    required this.startTime,
    required this.nextPlayerMovementPoints,
    required this.nextPlayerActionPoints,
    this.isNextPlayerVirtual = false,
  }) : super._();

  @override
  final String nextPlayerId;
  @override
  final int startTime;
  @override
  final int nextPlayerMovementPoints;
  @override
  final int nextPlayerActionPoints;
  @override
  @JsonKey()
  final bool isNextPlayerVirtual;

  @override
  String toString() {
    return 'TurnStartingEvent(nextPlayerId: $nextPlayerId, startTime: $startTime, nextPlayerMovementPoints: $nextPlayerMovementPoints, nextPlayerActionPoints: $nextPlayerActionPoints, isNextPlayerVirtual: $isNextPlayerVirtual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TurnStartingEventImpl &&
            (identical(other.nextPlayerId, nextPlayerId) ||
                other.nextPlayerId == nextPlayerId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(
                  other.nextPlayerMovementPoints,
                  nextPlayerMovementPoints,
                ) ||
                other.nextPlayerMovementPoints == nextPlayerMovementPoints) &&
            (identical(other.nextPlayerActionPoints, nextPlayerActionPoints) ||
                other.nextPlayerActionPoints == nextPlayerActionPoints) &&
            (identical(other.isNextPlayerVirtual, isNextPlayerVirtual) ||
                other.isNextPlayerVirtual == isNextPlayerVirtual));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    nextPlayerId,
    startTime,
    nextPlayerMovementPoints,
    nextPlayerActionPoints,
    isNextPlayerVirtual,
  );

  /// Create a copy of TurnStartingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TurnStartingEventImplCopyWith<_$TurnStartingEventImpl> get copyWith =>
      __$$TurnStartingEventImplCopyWithImpl<_$TurnStartingEventImpl>(
        this,
        _$identity,
      );
}

abstract class _TurnStartingEvent extends TurnStartingEvent {
  const factory _TurnStartingEvent({
    required final String nextPlayerId,
    required final int startTime,
    required final int nextPlayerMovementPoints,
    required final int nextPlayerActionPoints,
    final bool isNextPlayerVirtual,
  }) = _$TurnStartingEventImpl;
  const _TurnStartingEvent._() : super._();

  @override
  String get nextPlayerId;
  @override
  int get startTime;
  @override
  int get nextPlayerMovementPoints;
  @override
  int get nextPlayerActionPoints;
  @override
  bool get isNextPlayerVirtual;

  /// Create a copy of TurnStartingEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TurnStartingEventImplCopyWith<_$TurnStartingEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TurnStartingPlayerPointsEvent {
  String get nextPlayerId => throw _privateConstructorUsedError;
  int get movementPoints => throw _privateConstructorUsedError;
  int get actionPoints => throw _privateConstructorUsedError;

  /// Create a copy of TurnStartingPlayerPointsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TurnStartingPlayerPointsEventCopyWith<TurnStartingPlayerPointsEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TurnStartingPlayerPointsEventCopyWith<$Res> {
  factory $TurnStartingPlayerPointsEventCopyWith(
    TurnStartingPlayerPointsEvent value,
    $Res Function(TurnStartingPlayerPointsEvent) then,
  ) =
      _$TurnStartingPlayerPointsEventCopyWithImpl<
        $Res,
        TurnStartingPlayerPointsEvent
      >;
  @useResult
  $Res call({String nextPlayerId, int movementPoints, int actionPoints});
}

/// @nodoc
class _$TurnStartingPlayerPointsEventCopyWithImpl<
  $Res,
  $Val extends TurnStartingPlayerPointsEvent
>
    implements $TurnStartingPlayerPointsEventCopyWith<$Res> {
  _$TurnStartingPlayerPointsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TurnStartingPlayerPointsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextPlayerId = null,
    Object? movementPoints = null,
    Object? actionPoints = null,
  }) {
    return _then(
      _value.copyWith(
            nextPlayerId: null == nextPlayerId
                ? _value.nextPlayerId
                : nextPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
            movementPoints: null == movementPoints
                ? _value.movementPoints
                : movementPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            actionPoints: null == actionPoints
                ? _value.actionPoints
                : actionPoints // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TurnStartingPlayerPointsEventImplCopyWith<$Res>
    implements $TurnStartingPlayerPointsEventCopyWith<$Res> {
  factory _$$TurnStartingPlayerPointsEventImplCopyWith(
    _$TurnStartingPlayerPointsEventImpl value,
    $Res Function(_$TurnStartingPlayerPointsEventImpl) then,
  ) = __$$TurnStartingPlayerPointsEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nextPlayerId, int movementPoints, int actionPoints});
}

/// @nodoc
class __$$TurnStartingPlayerPointsEventImplCopyWithImpl<$Res>
    extends
        _$TurnStartingPlayerPointsEventCopyWithImpl<
          $Res,
          _$TurnStartingPlayerPointsEventImpl
        >
    implements _$$TurnStartingPlayerPointsEventImplCopyWith<$Res> {
  __$$TurnStartingPlayerPointsEventImplCopyWithImpl(
    _$TurnStartingPlayerPointsEventImpl _value,
    $Res Function(_$TurnStartingPlayerPointsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TurnStartingPlayerPointsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextPlayerId = null,
    Object? movementPoints = null,
    Object? actionPoints = null,
  }) {
    return _then(
      _$TurnStartingPlayerPointsEventImpl(
        nextPlayerId: null == nextPlayerId
            ? _value.nextPlayerId
            : nextPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        movementPoints: null == movementPoints
            ? _value.movementPoints
            : movementPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        actionPoints: null == actionPoints
            ? _value.actionPoints
            : actionPoints // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TurnStartingPlayerPointsEventImpl
    implements _TurnStartingPlayerPointsEvent {
  const _$TurnStartingPlayerPointsEventImpl({
    required this.nextPlayerId,
    required this.movementPoints,
    required this.actionPoints,
  });

  @override
  final String nextPlayerId;
  @override
  final int movementPoints;
  @override
  final int actionPoints;

  @override
  String toString() {
    return 'TurnStartingPlayerPointsEvent(nextPlayerId: $nextPlayerId, movementPoints: $movementPoints, actionPoints: $actionPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TurnStartingPlayerPointsEventImpl &&
            (identical(other.nextPlayerId, nextPlayerId) ||
                other.nextPlayerId == nextPlayerId) &&
            (identical(other.movementPoints, movementPoints) ||
                other.movementPoints == movementPoints) &&
            (identical(other.actionPoints, actionPoints) ||
                other.actionPoints == actionPoints));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nextPlayerId, movementPoints, actionPoints);

  /// Create a copy of TurnStartingPlayerPointsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TurnStartingPlayerPointsEventImplCopyWith<
    _$TurnStartingPlayerPointsEventImpl
  >
  get copyWith =>
      __$$TurnStartingPlayerPointsEventImplCopyWithImpl<
        _$TurnStartingPlayerPointsEventImpl
      >(this, _$identity);
}

abstract class _TurnStartingPlayerPointsEvent
    implements TurnStartingPlayerPointsEvent {
  const factory _TurnStartingPlayerPointsEvent({
    required final String nextPlayerId,
    required final int movementPoints,
    required final int actionPoints,
  }) = _$TurnStartingPlayerPointsEventImpl;

  @override
  String get nextPlayerId;
  @override
  int get movementPoints;
  @override
  int get actionPoints;

  /// Create a copy of TurnStartingPlayerPointsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TurnStartingPlayerPointsEventImplCopyWith<
    _$TurnStartingPlayerPointsEventImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlayerHealthUpdatedEvent {
  String get playerId => throw _privateConstructorUsedError;
  int get healthPoints => throw _privateConstructorUsedError;

  /// Create a copy of PlayerHealthUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerHealthUpdatedEventCopyWith<PlayerHealthUpdatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerHealthUpdatedEventCopyWith<$Res> {
  factory $PlayerHealthUpdatedEventCopyWith(
    PlayerHealthUpdatedEvent value,
    $Res Function(PlayerHealthUpdatedEvent) then,
  ) = _$PlayerHealthUpdatedEventCopyWithImpl<$Res, PlayerHealthUpdatedEvent>;
  @useResult
  $Res call({String playerId, int healthPoints});
}

/// @nodoc
class _$PlayerHealthUpdatedEventCopyWithImpl<
  $Res,
  $Val extends PlayerHealthUpdatedEvent
>
    implements $PlayerHealthUpdatedEventCopyWith<$Res> {
  _$PlayerHealthUpdatedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerHealthUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? healthPoints = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            healthPoints: null == healthPoints
                ? _value.healthPoints
                : healthPoints // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerHealthUpdatedEventImplCopyWith<$Res>
    implements $PlayerHealthUpdatedEventCopyWith<$Res> {
  factory _$$PlayerHealthUpdatedEventImplCopyWith(
    _$PlayerHealthUpdatedEventImpl value,
    $Res Function(_$PlayerHealthUpdatedEventImpl) then,
  ) = __$$PlayerHealthUpdatedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId, int healthPoints});
}

/// @nodoc
class __$$PlayerHealthUpdatedEventImplCopyWithImpl<$Res>
    extends
        _$PlayerHealthUpdatedEventCopyWithImpl<
          $Res,
          _$PlayerHealthUpdatedEventImpl
        >
    implements _$$PlayerHealthUpdatedEventImplCopyWith<$Res> {
  __$$PlayerHealthUpdatedEventImplCopyWithImpl(
    _$PlayerHealthUpdatedEventImpl _value,
    $Res Function(_$PlayerHealthUpdatedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerHealthUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? healthPoints = null}) {
    return _then(
      _$PlayerHealthUpdatedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        healthPoints: null == healthPoints
            ? _value.healthPoints
            : healthPoints // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PlayerHealthUpdatedEventImpl implements _PlayerHealthUpdatedEvent {
  const _$PlayerHealthUpdatedEventImpl({
    required this.playerId,
    required this.healthPoints,
  });

  @override
  final String playerId;
  @override
  final int healthPoints;

  @override
  String toString() {
    return 'PlayerHealthUpdatedEvent(playerId: $playerId, healthPoints: $healthPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerHealthUpdatedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.healthPoints, healthPoints) ||
                other.healthPoints == healthPoints));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId, healthPoints);

  /// Create a copy of PlayerHealthUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerHealthUpdatedEventImplCopyWith<_$PlayerHealthUpdatedEventImpl>
  get copyWith =>
      __$$PlayerHealthUpdatedEventImplCopyWithImpl<
        _$PlayerHealthUpdatedEventImpl
      >(this, _$identity);
}

abstract class _PlayerHealthUpdatedEvent implements PlayerHealthUpdatedEvent {
  const factory _PlayerHealthUpdatedEvent({
    required final String playerId,
    required final int healthPoints,
  }) = _$PlayerHealthUpdatedEventImpl;

  @override
  String get playerId;
  @override
  int get healthPoints;

  /// Create a copy of PlayerHealthUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerHealthUpdatedEventImplCopyWith<_$PlayerHealthUpdatedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateCountdownEvent {
  int get countdown => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCountdownEventCopyWith<UpdateCountdownEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCountdownEventCopyWith<$Res> {
  factory $UpdateCountdownEventCopyWith(
    UpdateCountdownEvent value,
    $Res Function(UpdateCountdownEvent) then,
  ) = _$UpdateCountdownEventCopyWithImpl<$Res, UpdateCountdownEvent>;
  @useResult
  $Res call({int countdown});
}

/// @nodoc
class _$UpdateCountdownEventCopyWithImpl<
  $Res,
  $Val extends UpdateCountdownEvent
>
    implements $UpdateCountdownEventCopyWith<$Res> {
  _$UpdateCountdownEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countdown = null}) {
    return _then(
      _value.copyWith(
            countdown: null == countdown
                ? _value.countdown
                : countdown // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateCountdownEventImplCopyWith<$Res>
    implements $UpdateCountdownEventCopyWith<$Res> {
  factory _$$UpdateCountdownEventImplCopyWith(
    _$UpdateCountdownEventImpl value,
    $Res Function(_$UpdateCountdownEventImpl) then,
  ) = __$$UpdateCountdownEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int countdown});
}

/// @nodoc
class __$$UpdateCountdownEventImplCopyWithImpl<$Res>
    extends _$UpdateCountdownEventCopyWithImpl<$Res, _$UpdateCountdownEventImpl>
    implements _$$UpdateCountdownEventImplCopyWith<$Res> {
  __$$UpdateCountdownEventImplCopyWithImpl(
    _$UpdateCountdownEventImpl _value,
    $Res Function(_$UpdateCountdownEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countdown = null}) {
    return _then(
      _$UpdateCountdownEventImpl(
        countdown: null == countdown
            ? _value.countdown
            : countdown // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UpdateCountdownEventImpl implements _UpdateCountdownEvent {
  const _$UpdateCountdownEventImpl({required this.countdown});

  @override
  final int countdown;

  @override
  String toString() {
    return 'UpdateCountdownEvent(countdown: $countdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCountdownEventImpl &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown));
  }

  @override
  int get hashCode => Object.hash(runtimeType, countdown);

  /// Create a copy of UpdateCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCountdownEventImplCopyWith<_$UpdateCountdownEventImpl>
  get copyWith =>
      __$$UpdateCountdownEventImplCopyWithImpl<_$UpdateCountdownEventImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateCountdownEvent implements UpdateCountdownEvent {
  const factory _UpdateCountdownEvent({required final int countdown}) =
      _$UpdateCountdownEventImpl;

  @override
  int get countdown;

  /// Create a copy of UpdateCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCountdownEventImplCopyWith<_$UpdateCountdownEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateStartingCountdownEvent {
  int get countdown => throw _privateConstructorUsedError;

  /// Create a copy of UpdateStartingCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateStartingCountdownEventCopyWith<UpdateStartingCountdownEvent>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateStartingCountdownEventCopyWith<$Res> {
  factory $UpdateStartingCountdownEventCopyWith(
    UpdateStartingCountdownEvent value,
    $Res Function(UpdateStartingCountdownEvent) then,
  ) =
      _$UpdateStartingCountdownEventCopyWithImpl<
        $Res,
        UpdateStartingCountdownEvent
      >;
  @useResult
  $Res call({int countdown});
}

/// @nodoc
class _$UpdateStartingCountdownEventCopyWithImpl<
  $Res,
  $Val extends UpdateStartingCountdownEvent
>
    implements $UpdateStartingCountdownEventCopyWith<$Res> {
  _$UpdateStartingCountdownEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateStartingCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countdown = null}) {
    return _then(
      _value.copyWith(
            countdown: null == countdown
                ? _value.countdown
                : countdown // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateStartingCountdownEventImplCopyWith<$Res>
    implements $UpdateStartingCountdownEventCopyWith<$Res> {
  factory _$$UpdateStartingCountdownEventImplCopyWith(
    _$UpdateStartingCountdownEventImpl value,
    $Res Function(_$UpdateStartingCountdownEventImpl) then,
  ) = __$$UpdateStartingCountdownEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int countdown});
}

/// @nodoc
class __$$UpdateStartingCountdownEventImplCopyWithImpl<$Res>
    extends
        _$UpdateStartingCountdownEventCopyWithImpl<
          $Res,
          _$UpdateStartingCountdownEventImpl
        >
    implements _$$UpdateStartingCountdownEventImplCopyWith<$Res> {
  __$$UpdateStartingCountdownEventImplCopyWithImpl(
    _$UpdateStartingCountdownEventImpl _value,
    $Res Function(_$UpdateStartingCountdownEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateStartingCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countdown = null}) {
    return _then(
      _$UpdateStartingCountdownEventImpl(
        countdown: null == countdown
            ? _value.countdown
            : countdown // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UpdateStartingCountdownEventImpl
    implements _UpdateStartingCountdownEvent {
  const _$UpdateStartingCountdownEventImpl({required this.countdown});

  @override
  final int countdown;

  @override
  String toString() {
    return 'UpdateStartingCountdownEvent(countdown: $countdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStartingCountdownEventImpl &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown));
  }

  @override
  int get hashCode => Object.hash(runtimeType, countdown);

  /// Create a copy of UpdateStartingCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStartingCountdownEventImplCopyWith<
    _$UpdateStartingCountdownEventImpl
  >
  get copyWith =>
      __$$UpdateStartingCountdownEventImplCopyWithImpl<
        _$UpdateStartingCountdownEventImpl
      >(this, _$identity);
}

abstract class _UpdateStartingCountdownEvent
    implements UpdateStartingCountdownEvent {
  const factory _UpdateStartingCountdownEvent({required final int countdown}) =
      _$UpdateStartingCountdownEventImpl;

  @override
  int get countdown;

  /// Create a copy of UpdateStartingCountdownEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStartingCountdownEventImplCopyWith<
    _$UpdateStartingCountdownEventImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurrentPlayerChangedEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of CurrentPlayerChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentPlayerChangedEventCopyWith<CurrentPlayerChangedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentPlayerChangedEventCopyWith<$Res> {
  factory $CurrentPlayerChangedEventCopyWith(
    CurrentPlayerChangedEvent value,
    $Res Function(CurrentPlayerChangedEvent) then,
  ) = _$CurrentPlayerChangedEventCopyWithImpl<$Res, CurrentPlayerChangedEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$CurrentPlayerChangedEventCopyWithImpl<
  $Res,
  $Val extends CurrentPlayerChangedEvent
>
    implements $CurrentPlayerChangedEventCopyWith<$Res> {
  _$CurrentPlayerChangedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentPlayerChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CurrentPlayerChangedEventImplCopyWith<$Res>
    implements $CurrentPlayerChangedEventCopyWith<$Res> {
  factory _$$CurrentPlayerChangedEventImplCopyWith(
    _$CurrentPlayerChangedEventImpl value,
    $Res Function(_$CurrentPlayerChangedEventImpl) then,
  ) = __$$CurrentPlayerChangedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$CurrentPlayerChangedEventImplCopyWithImpl<$Res>
    extends
        _$CurrentPlayerChangedEventCopyWithImpl<
          $Res,
          _$CurrentPlayerChangedEventImpl
        >
    implements _$$CurrentPlayerChangedEventImplCopyWith<$Res> {
  __$$CurrentPlayerChangedEventImplCopyWithImpl(
    _$CurrentPlayerChangedEventImpl _value,
    $Res Function(_$CurrentPlayerChangedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentPlayerChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$CurrentPlayerChangedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CurrentPlayerChangedEventImpl implements _CurrentPlayerChangedEvent {
  const _$CurrentPlayerChangedEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'CurrentPlayerChangedEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentPlayerChangedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of CurrentPlayerChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentPlayerChangedEventImplCopyWith<_$CurrentPlayerChangedEventImpl>
  get copyWith =>
      __$$CurrentPlayerChangedEventImplCopyWithImpl<
        _$CurrentPlayerChangedEventImpl
      >(this, _$identity);
}

abstract class _CurrentPlayerChangedEvent implements CurrentPlayerChangedEvent {
  const factory _CurrentPlayerChangedEvent({required final String playerId}) =
      _$CurrentPlayerChangedEventImpl;

  @override
  String get playerId;

  /// Create a copy of CurrentPlayerChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentPlayerChangedEventImplCopyWith<_$CurrentPlayerChangedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateScoreEvent {
  String get winnerId => throw _privateConstructorUsedError;

  /// Create a copy of UpdateScoreEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateScoreEventCopyWith<UpdateScoreEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateScoreEventCopyWith<$Res> {
  factory $UpdateScoreEventCopyWith(
    UpdateScoreEvent value,
    $Res Function(UpdateScoreEvent) then,
  ) = _$UpdateScoreEventCopyWithImpl<$Res, UpdateScoreEvent>;
  @useResult
  $Res call({String winnerId});
}

/// @nodoc
class _$UpdateScoreEventCopyWithImpl<$Res, $Val extends UpdateScoreEvent>
    implements $UpdateScoreEventCopyWith<$Res> {
  _$UpdateScoreEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateScoreEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? winnerId = null}) {
    return _then(
      _value.copyWith(
            winnerId: null == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateScoreEventImplCopyWith<$Res>
    implements $UpdateScoreEventCopyWith<$Res> {
  factory _$$UpdateScoreEventImplCopyWith(
    _$UpdateScoreEventImpl value,
    $Res Function(_$UpdateScoreEventImpl) then,
  ) = __$$UpdateScoreEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String winnerId});
}

/// @nodoc
class __$$UpdateScoreEventImplCopyWithImpl<$Res>
    extends _$UpdateScoreEventCopyWithImpl<$Res, _$UpdateScoreEventImpl>
    implements _$$UpdateScoreEventImplCopyWith<$Res> {
  __$$UpdateScoreEventImplCopyWithImpl(
    _$UpdateScoreEventImpl _value,
    $Res Function(_$UpdateScoreEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateScoreEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? winnerId = null}) {
    return _then(
      _$UpdateScoreEventImpl(
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateScoreEventImpl implements _UpdateScoreEvent {
  const _$UpdateScoreEventImpl({required this.winnerId});

  @override
  final String winnerId;

  @override
  String toString() {
    return 'UpdateScoreEvent(winnerId: $winnerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateScoreEventImpl &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, winnerId);

  /// Create a copy of UpdateScoreEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateScoreEventImplCopyWith<_$UpdateScoreEventImpl> get copyWith =>
      __$$UpdateScoreEventImplCopyWithImpl<_$UpdateScoreEventImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateScoreEvent implements UpdateScoreEvent {
  const factory _UpdateScoreEvent({required final String winnerId}) =
      _$UpdateScoreEventImpl;

  @override
  String get winnerId;

  /// Create a copy of UpdateScoreEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateScoreEventImplCopyWith<_$UpdateScoreEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FinishGameEvent {
  String get winnerId => throw _privateConstructorUsedError;

  /// Create a copy of FinishGameEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinishGameEventCopyWith<FinishGameEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinishGameEventCopyWith<$Res> {
  factory $FinishGameEventCopyWith(
    FinishGameEvent value,
    $Res Function(FinishGameEvent) then,
  ) = _$FinishGameEventCopyWithImpl<$Res, FinishGameEvent>;
  @useResult
  $Res call({String winnerId});
}

/// @nodoc
class _$FinishGameEventCopyWithImpl<$Res, $Val extends FinishGameEvent>
    implements $FinishGameEventCopyWith<$Res> {
  _$FinishGameEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinishGameEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? winnerId = null}) {
    return _then(
      _value.copyWith(
            winnerId: null == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinishGameEventImplCopyWith<$Res>
    implements $FinishGameEventCopyWith<$Res> {
  factory _$$FinishGameEventImplCopyWith(
    _$FinishGameEventImpl value,
    $Res Function(_$FinishGameEventImpl) then,
  ) = __$$FinishGameEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String winnerId});
}

/// @nodoc
class __$$FinishGameEventImplCopyWithImpl<$Res>
    extends _$FinishGameEventCopyWithImpl<$Res, _$FinishGameEventImpl>
    implements _$$FinishGameEventImplCopyWith<$Res> {
  __$$FinishGameEventImplCopyWithImpl(
    _$FinishGameEventImpl _value,
    $Res Function(_$FinishGameEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinishGameEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? winnerId = null}) {
    return _then(
      _$FinishGameEventImpl(
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FinishGameEventImpl implements _FinishGameEvent {
  const _$FinishGameEventImpl({required this.winnerId});

  @override
  final String winnerId;

  @override
  String toString() {
    return 'FinishGameEvent(winnerId: $winnerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinishGameEventImpl &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, winnerId);

  /// Create a copy of FinishGameEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinishGameEventImplCopyWith<_$FinishGameEventImpl> get copyWith =>
      __$$FinishGameEventImplCopyWithImpl<_$FinishGameEventImpl>(
        this,
        _$identity,
      );
}

abstract class _FinishGameEvent implements FinishGameEvent {
  const factory _FinishGameEvent({required final String winnerId}) =
      _$FinishGameEventImpl;

  @override
  String get winnerId;

  /// Create a copy of FinishGameEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinishGameEventImplCopyWith<_$FinishGameEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GameCanceledEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of GameCanceledEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCanceledEventCopyWith<GameCanceledEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCanceledEventCopyWith<$Res> {
  factory $GameCanceledEventCopyWith(
    GameCanceledEvent value,
    $Res Function(GameCanceledEvent) then,
  ) = _$GameCanceledEventCopyWithImpl<$Res, GameCanceledEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$GameCanceledEventCopyWithImpl<$Res, $Val extends GameCanceledEvent>
    implements $GameCanceledEventCopyWith<$Res> {
  _$GameCanceledEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameCanceledEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameCanceledEventImplCopyWith<$Res>
    implements $GameCanceledEventCopyWith<$Res> {
  factory _$$GameCanceledEventImplCopyWith(
    _$GameCanceledEventImpl value,
    $Res Function(_$GameCanceledEventImpl) then,
  ) = __$$GameCanceledEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$GameCanceledEventImplCopyWithImpl<$Res>
    extends _$GameCanceledEventCopyWithImpl<$Res, _$GameCanceledEventImpl>
    implements _$$GameCanceledEventImplCopyWith<$Res> {
  __$$GameCanceledEventImplCopyWithImpl(
    _$GameCanceledEventImpl _value,
    $Res Function(_$GameCanceledEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameCanceledEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$GameCanceledEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GameCanceledEventImpl implements _GameCanceledEvent {
  const _$GameCanceledEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'GameCanceledEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameCanceledEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of GameCanceledEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameCanceledEventImplCopyWith<_$GameCanceledEventImpl> get copyWith =>
      __$$GameCanceledEventImplCopyWithImpl<_$GameCanceledEventImpl>(
        this,
        _$identity,
      );
}

abstract class _GameCanceledEvent implements GameCanceledEvent {
  const factory _GameCanceledEvent({required final String playerId}) =
      _$GameCanceledEventImpl;

  @override
  String get playerId;

  /// Create a copy of GameCanceledEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameCanceledEventImplCopyWith<_$GameCanceledEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GameAbandonedEvent {}

/// @nodoc
abstract class $GameAbandonedEventCopyWith<$Res> {
  factory $GameAbandonedEventCopyWith(
    GameAbandonedEvent value,
    $Res Function(GameAbandonedEvent) then,
  ) = _$GameAbandonedEventCopyWithImpl<$Res, GameAbandonedEvent>;
}

/// @nodoc
class _$GameAbandonedEventCopyWithImpl<$Res, $Val extends GameAbandonedEvent>
    implements $GameAbandonedEventCopyWith<$Res> {
  _$GameAbandonedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GameAbandonedEventImplCopyWith<$Res> {
  factory _$$GameAbandonedEventImplCopyWith(
    _$GameAbandonedEventImpl value,
    $Res Function(_$GameAbandonedEventImpl) then,
  ) = __$$GameAbandonedEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GameAbandonedEventImplCopyWithImpl<$Res>
    extends _$GameAbandonedEventCopyWithImpl<$Res, _$GameAbandonedEventImpl>
    implements _$$GameAbandonedEventImplCopyWith<$Res> {
  __$$GameAbandonedEventImplCopyWithImpl(
    _$GameAbandonedEventImpl _value,
    $Res Function(_$GameAbandonedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GameAbandonedEventImpl implements _GameAbandonedEvent {
  const _$GameAbandonedEventImpl();

  @override
  String toString() {
    return 'GameAbandonedEvent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GameAbandonedEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _GameAbandonedEvent implements GameAbandonedEvent {
  const factory _GameAbandonedEvent() = _$GameAbandonedEventImpl;
}

/// @nodoc
mixin _$PlayerAbandonedEvent {
  String get playerId => throw _privateConstructorUsedError;

  /// Create a copy of PlayerAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerAbandonedEventCopyWith<PlayerAbandonedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerAbandonedEventCopyWith<$Res> {
  factory $PlayerAbandonedEventCopyWith(
    PlayerAbandonedEvent value,
    $Res Function(PlayerAbandonedEvent) then,
  ) = _$PlayerAbandonedEventCopyWithImpl<$Res, PlayerAbandonedEvent>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class _$PlayerAbandonedEventCopyWithImpl<
  $Res,
  $Val extends PlayerAbandonedEvent
>
    implements $PlayerAbandonedEventCopyWith<$Res> {
  _$PlayerAbandonedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerAbandonedEventImplCopyWith<$Res>
    implements $PlayerAbandonedEventCopyWith<$Res> {
  factory _$$PlayerAbandonedEventImplCopyWith(
    _$PlayerAbandonedEventImpl value,
    $Res Function(_$PlayerAbandonedEventImpl) then,
  ) = __$$PlayerAbandonedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$PlayerAbandonedEventImplCopyWithImpl<$Res>
    extends _$PlayerAbandonedEventCopyWithImpl<$Res, _$PlayerAbandonedEventImpl>
    implements _$$PlayerAbandonedEventImplCopyWith<$Res> {
  __$$PlayerAbandonedEventImplCopyWithImpl(
    _$PlayerAbandonedEventImpl _value,
    $Res Function(_$PlayerAbandonedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$PlayerAbandonedEventImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PlayerAbandonedEventImpl implements _PlayerAbandonedEvent {
  const _$PlayerAbandonedEventImpl({required this.playerId});

  @override
  final String playerId;

  @override
  String toString() {
    return 'PlayerAbandonedEvent(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerAbandonedEventImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of PlayerAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerAbandonedEventImplCopyWith<_$PlayerAbandonedEventImpl>
  get copyWith =>
      __$$PlayerAbandonedEventImplCopyWithImpl<_$PlayerAbandonedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _PlayerAbandonedEvent implements PlayerAbandonedEvent {
  const factory _PlayerAbandonedEvent({required final String playerId}) =
      _$PlayerAbandonedEventImpl;

  @override
  String get playerId;

  /// Create a copy of PlayerAbandonedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerAbandonedEventImplCopyWith<_$PlayerAbandonedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SpawnPointClearedEvent {
  GameBoardPosition get position => throw _privateConstructorUsedError;

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpawnPointClearedEventCopyWith<SpawnPointClearedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpawnPointClearedEventCopyWith<$Res> {
  factory $SpawnPointClearedEventCopyWith(
    SpawnPointClearedEvent value,
    $Res Function(SpawnPointClearedEvent) then,
  ) = _$SpawnPointClearedEventCopyWithImpl<$Res, SpawnPointClearedEvent>;
  @useResult
  $Res call({GameBoardPosition position});

  $GameBoardPositionCopyWith<$Res> get position;
}

/// @nodoc
class _$SpawnPointClearedEventCopyWithImpl<
  $Res,
  $Val extends SpawnPointClearedEvent
>
    implements $SpawnPointClearedEventCopyWith<$Res> {
  _$SpawnPointClearedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null}) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as GameBoardPosition,
          )
          as $Val,
    );
  }

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameBoardPositionCopyWith<$Res> get position {
    return $GameBoardPositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpawnPointClearedEventImplCopyWith<$Res>
    implements $SpawnPointClearedEventCopyWith<$Res> {
  factory _$$SpawnPointClearedEventImplCopyWith(
    _$SpawnPointClearedEventImpl value,
    $Res Function(_$SpawnPointClearedEventImpl) then,
  ) = __$$SpawnPointClearedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameBoardPosition position});

  @override
  $GameBoardPositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$SpawnPointClearedEventImplCopyWithImpl<$Res>
    extends
        _$SpawnPointClearedEventCopyWithImpl<$Res, _$SpawnPointClearedEventImpl>
    implements _$$SpawnPointClearedEventImplCopyWith<$Res> {
  __$$SpawnPointClearedEventImplCopyWithImpl(
    _$SpawnPointClearedEventImpl _value,
    $Res Function(_$SpawnPointClearedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null}) {
    return _then(
      _$SpawnPointClearedEventImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as GameBoardPosition,
      ),
    );
  }
}

/// @nodoc

class _$SpawnPointClearedEventImpl implements _SpawnPointClearedEvent {
  const _$SpawnPointClearedEventImpl({required this.position});

  @override
  final GameBoardPosition position;

  @override
  String toString() {
    return 'SpawnPointClearedEvent(position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpawnPointClearedEventImpl &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode => Object.hash(runtimeType, position);

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpawnPointClearedEventImplCopyWith<_$SpawnPointClearedEventImpl>
  get copyWith =>
      __$$SpawnPointClearedEventImplCopyWithImpl<_$SpawnPointClearedEventImpl>(
        this,
        _$identity,
      );
}

abstract class _SpawnPointClearedEvent implements SpawnPointClearedEvent {
  const factory _SpawnPointClearedEvent({
    required final GameBoardPosition position,
  }) = _$SpawnPointClearedEventImpl;

  @override
  GameBoardPosition get position;

  /// Create a copy of SpawnPointClearedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpawnPointClearedEventImplCopyWith<_$SpawnPointClearedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrganizatorChangedEvent {
  String get newHostId => throw _privateConstructorUsedError;

  /// Create a copy of OrganizatorChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizatorChangedEventCopyWith<OrganizatorChangedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizatorChangedEventCopyWith<$Res> {
  factory $OrganizatorChangedEventCopyWith(
    OrganizatorChangedEvent value,
    $Res Function(OrganizatorChangedEvent) then,
  ) = _$OrganizatorChangedEventCopyWithImpl<$Res, OrganizatorChangedEvent>;
  @useResult
  $Res call({String newHostId});
}

/// @nodoc
class _$OrganizatorChangedEventCopyWithImpl<
  $Res,
  $Val extends OrganizatorChangedEvent
>
    implements $OrganizatorChangedEventCopyWith<$Res> {
  _$OrganizatorChangedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizatorChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newHostId = null}) {
    return _then(
      _value.copyWith(
            newHostId: null == newHostId
                ? _value.newHostId
                : newHostId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizatorChangedEventImplCopyWith<$Res>
    implements $OrganizatorChangedEventCopyWith<$Res> {
  factory _$$OrganizatorChangedEventImplCopyWith(
    _$OrganizatorChangedEventImpl value,
    $Res Function(_$OrganizatorChangedEventImpl) then,
  ) = __$$OrganizatorChangedEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newHostId});
}

/// @nodoc
class __$$OrganizatorChangedEventImplCopyWithImpl<$Res>
    extends
        _$OrganizatorChangedEventCopyWithImpl<
          $Res,
          _$OrganizatorChangedEventImpl
        >
    implements _$$OrganizatorChangedEventImplCopyWith<$Res> {
  __$$OrganizatorChangedEventImplCopyWithImpl(
    _$OrganizatorChangedEventImpl _value,
    $Res Function(_$OrganizatorChangedEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizatorChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newHostId = null}) {
    return _then(
      _$OrganizatorChangedEventImpl(
        newHostId: null == newHostId
            ? _value.newHostId
            : newHostId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OrganizatorChangedEventImpl implements _OrganizatorChangedEvent {
  const _$OrganizatorChangedEventImpl({required this.newHostId});

  @override
  final String newHostId;

  @override
  String toString() {
    return 'OrganizatorChangedEvent(newHostId: $newHostId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizatorChangedEventImpl &&
            (identical(other.newHostId, newHostId) ||
                other.newHostId == newHostId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newHostId);

  /// Create a copy of OrganizatorChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizatorChangedEventImplCopyWith<_$OrganizatorChangedEventImpl>
  get copyWith =>
      __$$OrganizatorChangedEventImplCopyWithImpl<
        _$OrganizatorChangedEventImpl
      >(this, _$identity);
}

abstract class _OrganizatorChangedEvent implements OrganizatorChangedEvent {
  const factory _OrganizatorChangedEvent({required final String newHostId}) =
      _$OrganizatorChangedEventImpl;

  @override
  String get newHostId;

  /// Create a copy of OrganizatorChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizatorChangedEventImplCopyWith<_$OrganizatorChangedEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DoorToggledEvent {
  int get x => throw _privateConstructorUsedError;
  int get y => throw _privateConstructorUsedError;

  /// Create a copy of DoorToggledEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoorToggledEventCopyWith<DoorToggledEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoorToggledEventCopyWith<$Res> {
  factory $DoorToggledEventCopyWith(
    DoorToggledEvent value,
    $Res Function(DoorToggledEvent) then,
  ) = _$DoorToggledEventCopyWithImpl<$Res, DoorToggledEvent>;
  @useResult
  $Res call({int x, int y});
}

/// @nodoc
class _$DoorToggledEventCopyWithImpl<$Res, $Val extends DoorToggledEvent>
    implements $DoorToggledEventCopyWith<$Res> {
  _$DoorToggledEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoorToggledEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _value.copyWith(
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as int,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DoorToggledEventImplCopyWith<$Res>
    implements $DoorToggledEventCopyWith<$Res> {
  factory _$$DoorToggledEventImplCopyWith(
    _$DoorToggledEventImpl value,
    $Res Function(_$DoorToggledEventImpl) then,
  ) = __$$DoorToggledEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int x, int y});
}

/// @nodoc
class __$$DoorToggledEventImplCopyWithImpl<$Res>
    extends _$DoorToggledEventCopyWithImpl<$Res, _$DoorToggledEventImpl>
    implements _$$DoorToggledEventImplCopyWith<$Res> {
  __$$DoorToggledEventImplCopyWithImpl(
    _$DoorToggledEventImpl _value,
    $Res Function(_$DoorToggledEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoorToggledEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _$DoorToggledEventImpl(
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as int,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DoorToggledEventImpl implements _DoorToggledEvent {
  const _$DoorToggledEventImpl({required this.x, required this.y});

  @override
  final int x;
  @override
  final int y;

  @override
  String toString() {
    return 'DoorToggledEvent(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoorToggledEventImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of DoorToggledEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoorToggledEventImplCopyWith<_$DoorToggledEventImpl> get copyWith =>
      __$$DoorToggledEventImplCopyWithImpl<_$DoorToggledEventImpl>(
        this,
        _$identity,
      );
}

abstract class _DoorToggledEvent implements DoorToggledEvent {
  const factory _DoorToggledEvent({
    required final int x,
    required final int y,
  }) = _$DoorToggledEventImpl;

  @override
  int get x;
  @override
  int get y;

  /// Create a copy of DoorToggledEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoorToggledEventImplCopyWith<_$DoorToggledEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
